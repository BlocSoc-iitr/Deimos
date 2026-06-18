import { query } from '../config/database.js';
import { logger } from '../utils/logger.js';
import { validateBenchmark } from '../middleware/validateBenchmark.js';

// Columns inserted for each benchmark row, in order. Shared by the single and
// bulk endpoints so the two can never drift.
const INSERT_COLUMNS = [
  'circuit', 'framework', 'language', 'input_size', 'proving_time_ms', 'verification_time_ms',
  'proof_size', 'timestamp', 'created_at', 'custom_inputs',
  'platform', 'device', 'manufacturer', 'device_id', 'system_version',
  'total_physical_memory', 'memory_used_before_proof', 'peak_memory_usage',
  'memory_consumed_by_proof', 'peak_memory_load_percentage', 'memory_consumed_percentage',
  'cpu_time_ms', 'cpu_percent',
];

// Conflict target = the partial unique index in schema.sql. Lets ON CONFLICT
// dedupe on (device_id, circuit, framework, language, input_size) for rows that
// have a device_id.
const ON_CONFLICT =
  'ON CONFLICT (device_id, circuit, framework, language, input_size) WHERE device_id IS NOT NULL DO NOTHING';

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
    data.timestamp || nowIso,
    nowIso,
    data.customInputs ? JSON.stringify(data.customInputs) : null,
    deviceInfo.platform,
    deviceInfo.device,
    deviceInfo.manufacturer || null,
    deviceInfo.deviceId || null,
    deviceInfo.systemVersion || null,
    memory.totalPhysicalMemory || null,
    memory.memoryUsedBeforeProof || null,
    memory.peakMemoryUsage || null,
    memory.memoryConsumedByProof || null,
    memory.peakMemoryLoadInPercentage || null,
    memory.memoryConsumedInPercentage || null,
    cpu.cpuTimeMs ?? null,
    cpu.cpuPercent ?? null,
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

    // ON CONFLICT makes the insert idempotent on the dedup key; an empty result
    // means the row already existed.
    const result = await query(
      `INSERT INTO benchmarks (${INSERT_COLUMNS.join(', ')})
       VALUES (${placeholders})
       ${ON_CONFLICT}
       RETURNING id`,
      values
    );

    if (result.rows.length === 0) {
      logger.info(`Duplicate benchmark detected - Circuit: ${data.circuit}, Framework: ${data.framework}, Language: ${data.language}, InputSize: ${data.inputSize ?? null}, DeviceId: ${data.deviceInfo?.deviceId}`);
      return res.status(200).json({
        success: false,
        message: 'Benchmark data already exists for this circuit/framework/language/inputSize/device combination',
        duplicate: true,
        deviceId: data.deviceInfo?.deviceId,
        circuit: data.circuit,
        framework: data.framework,
        language: data.language,
        inputSize: data.inputSize ?? null,
      });
    }

    const insertedId = result.rows[0].id;
    logger.info(`Benchmark data saved successfully with ID: ${insertedId}`);

    res.status(201).json({
      success: true,
      message: 'Benchmark result received and saved successfully',
      documentId: insertedId.toString(),
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
 * Inserts in a single multi-row statement (chunked if very large); duplicates
 * on the dedup key are skipped via ON CONFLICT DO NOTHING.
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

    const nowIso = new Date().toISOString();
    const colCount = INSERT_COLUMNS.length;
    let inserted = 0;

    for (let start = 0; start < results.length; start += MAX_ROWS_PER_INSERT) {
      const chunk = results.slice(start, start + MAX_ROWS_PER_INSERT);
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
         RETURNING id`,
        params
      );
      inserted += result.rows.length;
    }

    const skipped = results.length - inserted; // duplicates among valid items
    logger.info(`Bulk benchmark upload: ${inserted} inserted, ${skipped} duplicate, ${rejected} rejected of ${incoming.length}`);

    res.status(201).json({
      success: true,
      message: `Saved ${inserted} of ${incoming.length} benchmark results`,
      inserted,
      skipped,
      rejected,
      total: incoming.length,
      receivedAt: nowIso,
    });
  } catch (error) {
    logger.error('Error receiving bulk benchmark results:', error);
    res.status(500).json({ error: error.message });
  }
};
