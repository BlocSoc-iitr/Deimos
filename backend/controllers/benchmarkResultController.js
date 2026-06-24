import { query } from '../config/database.js';
import { logger } from '../utils/logger.js';
import { validateBenchmark } from '../middleware/validateBenchmark.js';

// Columns inserted for each benchmark row, in order. Shared by the single and
// bulk endpoints so the two can never drift.
const INSERT_COLUMNS = [
  'circuit', 'framework', 'language', 'input_size', 'proving_time_ms', 'verification_time_ms',
  'proof_size', 'preprocessing_size', 'timestamp', 'created_at', 'custom_inputs',
  'platform', 'device', 'manufacturer', 'device_id', 'system_version',
  'total_physical_memory', 'peak_memory_usage', 'peak_memory_load_percentage',
  'cpu_time_ms', 'cpu_percent', 'temperature_c',
];

// On conflict (same device_id, circuit, framework, language, input_size) we
// fold the incoming metrics into a running mean rather than reject them:
//   new_avg = (old_avg * sample_count + incoming) / (sample_count + 1)
// Each averaging expression is null-safe — a NULL on either side keeps the
// other value — so optional metrics (preprocessing, temperature) don't poison
// the row. Integer/bigint columns round to whole numbers; decimals to 2 places.
const avg = (col, decimals) => {
  const expr =
    `(benchmarks.${col}::numeric * benchmarks.sample_count + EXCLUDED.${col}) ` +
    `/ (benchmarks.sample_count + 1)`;
  const rounded = decimals != null ? `ROUND(${expr}, ${decimals})` : `ROUND(${expr})`;
  return `${col} = CASE
      WHEN EXCLUDED.${col} IS NULL THEN benchmarks.${col}
      WHEN benchmarks.${col} IS NULL THEN EXCLUDED.${col}
      ELSE ${rounded}
    END`;
};

const AGGREGATE_SET = [
  avg('proving_time_ms'),
  avg('verification_time_ms'),
  avg('proof_size'),
  avg('preprocessing_size'),
  avg('peak_memory_usage'),
  avg('cpu_time_ms'),
  avg('peak_memory_load_percentage', 2),
  avg('cpu_percent', 2),
  avg('temperature_c', 2),
  // Bump the sample count and surface the latest contribution's timestamp.
  'sample_count = benchmarks.sample_count + 1',
  'timestamp = EXCLUDED.timestamp',
].join(',\n    ');

// Conflict target = the partial unique index in schema.sql (rows with a
// device_id). DO UPDATE turns a re-upload into an aggregation step.
const ON_CONFLICT =
  `ON CONFLICT (device_id, circuit, framework, language, input_size) ` +
  `WHERE device_id IS NOT NULL DO UPDATE SET\n    ${AGGREGATE_SET}`;

// Conflict key used to collapse duplicates *within a single bulk request*:
// Postgres forbids a DO UPDATE touching the same row twice in one statement.
const conflictKey = (data) =>
  `${data.deviceInfo?.deviceId}|${data.circuit}|${data.framework}|${data.language}|${data.inputSize ?? ''}`;

/**
 * Maps an incoming benchmark payload to the ordered value array matching
 * INSERT_COLUMNS. `nowIso` is reused for created_at (and timestamp fallback).
 */
function extractRowValues(data, nowIso) {
  const deviceInfo = data.deviceInfo || {};
  const memory = deviceInfo.memory || {};
  const cpu = deviceInfo.cpu || {};
  return [
    data.circuit,
    data.framework,
    data.language,
    data.inputSize ?? null,
    data.provingTimeMiliSeconds,
    data.verificationTimeMiliSeconds,
    data.proofSize,
    data.preprocessingSize ?? null,
    data.timestamp || nowIso,
    nowIso,
    data.customInputs ? JSON.stringify(data.customInputs) : null,
    deviceInfo.platform,
    deviceInfo.device,
    deviceInfo.manufacturer || null,
    deviceInfo.deviceId || null,
    deviceInfo.systemVersion || null,
    // Use ?? (not ||) so a legitimate 0 isn't turned into NULL.
    memory.totalPhysicalMemory ?? null,
    memory.peakMemoryUsage ?? null,
    memory.peakMemoryLoadInPercentage ?? null,
    cpu.cpuTimeMs ?? null,
    cpu.cpuPercent ?? null,
    data.temperatureC ?? null,
  ];
}

/**
 * Receive a single benchmark result from the mobile app (single-run flow).
 */
export const receiveBenchmarkResult = async (req, res) => {
  try {
    const data = req.body;

    const errors = validateBenchmark(data);
    if (errors.length > 0) {
      logger.info(`Rejected malformed benchmark: ${errors.slice(0, 5).join('; ')}`);
      return res.status(400).json({ error: 'Invalid benchmark payload', details: errors });
    }

    const nowIso = new Date().toISOString();
    const values = extractRowValues(data, nowIso);
    const placeholders = values.map((_, i) => `$${i + 1}`).join(', ');

    // ON CONFLICT folds a re-upload into the existing row's running mean and
    // returns it (sample_count > 1 ⇒ this was an aggregation, not a fresh row).
    const result = await query(
      `INSERT INTO benchmarks (${INSERT_COLUMNS.join(', ')})
       VALUES (${placeholders})
       ${ON_CONFLICT}
       RETURNING id, sample_count`,
      values
    );

    const row = result.rows[0];
    const aggregated = row.sample_count > 1;
    if (aggregated) {
      logger.info(`Benchmark aggregated into ID ${row.id} (now mean of ${row.sample_count} runs) - ${data.circuit}/${data.framework}/${data.language}/${data.inputSize ?? null}`);
    } else {
      logger.info(`Benchmark data saved successfully with ID: ${row.id}`);
    }

    res.status(201).json({
      success: true,
      message: aggregated
        ? `Benchmark averaged into existing record (now mean of ${row.sample_count} runs)`
        : 'Benchmark result received and saved successfully',
      documentId: row.id.toString(),
      aggregated,
      sampleCount: row.sample_count,
      receivedAt: nowIso,
    });
  } catch (error) {
    logger.error('Error receiving benchmark result:', error);
    res.status(500).json({ error: error.message });
  }
};

// Postgres caps a statement at 65535 bound parameters; chunk large batches.
const MAX_ROWS_PER_INSERT = Math.floor(60000 / INSERT_COLUMNS.length);

/**
 * Receive many benchmark results in one request (batch "Prove and Verify All"
 * flow). Body: { results: [ ...same shape as the single endpoint... ] }.
 * Inserts in a single multi-row statement (chunked if very large); a row that
 * collides with an existing one on the dedup key is folded into its running
 * mean via ON CONFLICT DO UPDATE.
 */
export const receiveBenchmarkResults = async (req, res) => {
  try {
    const incoming = req.body?.results;
    if (!Array.isArray(incoming) || incoming.length === 0) {
      return res.status(400).json({ error: 'Request body must be { results: [...] } with at least one item' });
    }

    // Drop malformed items rather than failing the whole batch; keep the valid ones.
    const results = [];
    let rejected = 0;
    for (const item of incoming) {
      if (validateBenchmark(item).length === 0) results.push(item);
      else rejected++;
    }
    if (rejected > 0) logger.info(`Bulk upload: dropped ${rejected} malformed of ${incoming.length}`);
    if (results.length === 0) {
      return res.status(400).json({ error: 'No valid benchmark results', total: incoming.length, rejected });
    }

    // Collapse duplicates within this payload (DO UPDATE can't touch a row twice
    // in one statement). Keep the last occurrence; rows without a device_id never
    // conflict, so they pass through untouched. Cross-request re-uploads still
    // aggregate at the database.
    const deduped = [];
    const seen = new Map();
    for (const data of results) {
      if (!data.deviceInfo?.deviceId) { deduped.push(data); continue; }
      const key = conflictKey(data);
      if (seen.has(key)) deduped[seen.get(key)] = data;
      else { seen.set(key, deduped.length); deduped.push(data); }
    }
    const collapsed = results.length - deduped.length;

    const nowIso = new Date().toISOString();
    let insertedNew = 0;
    let aggregated = 0;

    for (let start = 0; start < deduped.length; start += MAX_ROWS_PER_INSERT) {
      const chunk = deduped.slice(start, start + MAX_ROWS_PER_INSERT);
      const params = [];
      const rowsSql = chunk.map((data) => {
        const values = extractRowValues(data, nowIso);
        const base = params.length;
        params.push(...values);
        return `(${values.map((_, i) => `$${base + i + 1}`).join(', ')})`;
      });

      const result = await query(
        `INSERT INTO benchmarks (${INSERT_COLUMNS.join(', ')})
         VALUES ${rowsSql.join(', ')}
         ${ON_CONFLICT}
         RETURNING id, sample_count`,
        params
      );
      for (const r of result.rows) {
        if (r.sample_count > 1) aggregated++;
        else insertedNew++;
      }
    }

    logger.info(`Bulk benchmark upload: ${insertedNew} new, ${aggregated} aggregated, ${collapsed} collapsed in-payload, ${rejected} rejected of ${incoming.length}`);

    res.status(201).json({
      success: true,
      message: `Saved ${insertedNew} new and aggregated ${aggregated} of ${incoming.length} benchmark results`,
      inserted: insertedNew,
      aggregated,
      collapsed,
      rejected,
      total: incoming.length,
      receivedAt: nowIso,
    });
  } catch (error) {
    logger.error('Error receiving bulk benchmark results:', error);
    res.status(500).json({ error: error.message });
  }
};
