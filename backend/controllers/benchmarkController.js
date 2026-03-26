import { query } from '../config/database.js';
import { logger } from '../utils/logger.js';

/**
 * Convert a database row back to the original API response format
 */
function rowToApiFormat(row) {
  const toNumberOrNull = (value) => (value != null ? Number(value) : null);
  const toFloatOrNull = (value) => (value != null ? parseFloat(value) : null);

  const hasMemoryData = [
    row.total_physical_memory,
    row.memory_used_before_proof,
    row.peak_memory_usage,
    row.memory_consumed_by_proof,
    row.peak_memory_load_percentage,
    row.memory_consumed_percentage,
  ].some((value) => value != null);

  const hasBatteryData = [
    row.battery_before_proof,
    row.battery_after_proof,
    row.battery_consumed,
  ].some((value) => value != null);

  const deviceInfo = {
    platform: row.platform,
    device: row.device,
  };

  if (hasMemoryData) {
    deviceInfo.memory = {
      totalPhysicalMemory: toNumberOrNull(row.total_physical_memory),
      memoryUsedBeforeProof: toNumberOrNull(row.memory_used_before_proof),
      peakMemoryUsage: toNumberOrNull(row.peak_memory_usage),
      memoryConsumedByProof: toNumberOrNull(row.memory_consumed_by_proof),
      peakMemoryLoadInPercentage: toFloatOrNull(row.peak_memory_load_percentage),
      memoryConsumedInPercentage: toFloatOrNull(row.memory_consumed_percentage),
    };
  }

  if (hasBatteryData) {
    deviceInfo.battery = {
      batteryBeforeProof: row.battery_before_proof,
      batteryAfterProof: row.battery_after_proof,
      batteryConsumed: row.battery_consumed,
    };
  }

  const result = {
    id: row.id.toString(),
    circuit: row.circuit,
    framework: row.framework,
    language: row.language,
    provingTimeMiliSeconds: row.proving_time_ms,
    verificationTimeMiliSeconds: row.verification_time_ms,
    proofSize: row.proof_size,
    timestamp: row.timestamp?.toISOString(),
    createdAt: row.created_at?.toISOString(),
    customInputs: row.custom_inputs || undefined,
    deviceInfo,
  };

  
  result.deviceInfo.manufacturer = row.manufacturer;
  result.deviceInfo.deviceVersion = row.device_version;
  result.deviceInfo.deviceId = row.device_id;
  result.deviceInfo.systemName = row.system_name;
  result.deviceInfo.systemVersion = row.system_version;
  result.deviceInfo.isPhysicalDevice = row.is_physical_device;


  return result;
}

/**
 * Get filtered and paginated benchmark data
 */
export const getBenchmarks = async (req, res) => {
  try {
    const {
      circuit = 'all',
      framework = 'all',
      language = 'all',
      platform = 'all',
      page = '1',
      limit = '10'
    } = req.query;

    const pageNum = parseInt(page);
    const limitNum = parseInt(limit);

    if (isNaN(pageNum) || pageNum < 1) {
      return res.status(400).json({ error: 'Invalid page number' });
    }

    if (isNaN(limitNum) || limitNum < 1) {
      return res.status(400).json({ error: 'Invalid limit' });
    }

    // Build parameterized query
    const conditions = [];
    const params = [];
    let paramIndex = 1;

    if (circuit !== 'all') {
      conditions.push(`circuit = $${paramIndex++}`);
      params.push(circuit);
    }
    if (framework !== 'all') {
      conditions.push(`framework = $${paramIndex++}`);
      params.push(framework);
    }
    if (language !== 'all') {
      conditions.push(`language = $${paramIndex++}`);
      params.push(language);
    }
    if (platform !== 'all') {
      conditions.push(`platform = $${paramIndex++}`);
      params.push(platform);
    }

    const whereClause = conditions.length > 0
      ? `WHERE ${conditions.join(' AND ')}`
      : '';

    // Get total count
    const countResult = await query(
      `SELECT COUNT(*) FROM benchmarks ${whereClause}`,
      params
    );
    const totalCount = parseInt(countResult.rows[0].count);

    // Get paginated data
    const offset = (pageNum - 1) * limitNum;
    const dataResult = await query(
      `SELECT * FROM benchmarks ${whereClause} ORDER BY timestamp DESC LIMIT $${paramIndex++} OFFSET $${paramIndex++}`,
      [...params, limitNum, offset]
    );

    const totalPages = Math.ceil(totalCount / limitNum);

    res.json({
      data: dataResult.rows.map(rowToApiFormat),
      pagination: {
        currentPage: pageNum,
        totalPages,
        totalCount,
        limit: limitNum,
        hasNextPage: pageNum < totalPages,
        hasPrevPage: pageNum > 1
      }
    });
  } catch (error) {
    logger.error('Error fetching benchmarks:', error);
    res.status(500).json({ error: error.message });
  }
};

/**
 * Get unique filter values
 */
export const getFilters = async (req, res) => {
  try {
    const [circuits, frameworks, languages, platforms] = await Promise.all([
      query('SELECT DISTINCT circuit FROM benchmarks ORDER BY circuit'),
      query('SELECT DISTINCT framework FROM benchmarks ORDER BY framework'),
      query('SELECT DISTINCT language FROM benchmarks ORDER BY language'),
      query('SELECT DISTINCT platform FROM benchmarks ORDER BY platform'),
    ]);

    res.json({
      circuits: ['all', ...circuits.rows.map(r => r.circuit)],
      frameworks: ['all', ...frameworks.rows.map(r => r.framework)],
      languages: ['all', ...languages.rows.map(r => r.language)],
      platforms: ['all', ...platforms.rows.map(r => r.platform)],
    });
  } catch (error) {
    logger.error('Error fetching filters:', error);
    res.status(500).json({ error: error.message });
  }
};
