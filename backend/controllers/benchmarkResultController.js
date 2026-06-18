import { query } from '../config/database.js';
import { logger } from '../utils/logger.js';

/**
 * Receive benchmark result data from mobile app
 */
export const receiveBenchmarkResult = async (req, res) => {
  try {
    const data = req.body;

    // Check for duplicate based on combination of circuit, framework, language, input size and deviceId
    const deviceId = data.deviceInfo?.deviceId;
    const circuit = data.circuit;
    const framework = data.framework;
    const language = data.language;
    const inputSize = data.inputSize ?? null;

    if (deviceId && circuit && framework && language) {
      // input_size is part of the uniqueness key so results for different
      // input sizes aren't rejected as duplicates. NULL is matched explicitly
      // since `= NULL` never holds in SQL.
      const existing = await query(
        `SELECT id FROM benchmarks
         WHERE device_id = $1 AND circuit = $2 AND framework = $3 AND language = $4
           AND input_size IS NOT DISTINCT FROM $5
         LIMIT 1`,
        [deviceId, circuit, framework, language, inputSize]
      );

      if (existing.rows.length > 0) {
        logger.info(`Duplicate benchmark detected - Circuit: ${circuit}, Framework: ${framework}, Language: ${language}, InputSize: ${inputSize}, DeviceId: ${deviceId}`);
        return res.status(200).json({
          success: false,
          message: 'Benchmark data already exists for this circuit/framework/language/inputSize/device combination',
          duplicate: true,
          deviceId,
          circuit,
          framework,
          language,
          inputSize
        });
      }
    }

    const deviceInfo = data.deviceInfo || {};
    const memory = deviceInfo.memory || {};
    const battery = deviceInfo.battery || {};

    const result = await query(
      `INSERT INTO benchmarks (
        circuit, framework, language, input_size, proving_time_ms, verification_time_ms,
        proof_size, timestamp, created_at, custom_inputs,
        platform, device, manufacturer, device_version, device_id,
        system_name, system_version, is_physical_device,
        total_physical_memory, memory_used_before_proof, peak_memory_usage,
        memory_consumed_by_proof, peak_memory_load_percentage, memory_consumed_percentage,
        battery_before_proof, battery_after_proof, battery_consumed
      ) VALUES (
        $1, $2, $3, $4, $5,
        $6, $7, $8, $9, $10,
        $11, $12, $13, $14, $15,
        $16, $17, $18, $19, $20,
        $21, $22, $23,
        $24, $25, $26,
        $27
      ) RETURNING id`,
      [
        circuit,
        framework,
        language,
        inputSize,
        data.provingTimeMiliSeconds,
        data.verificationTimeMiliSeconds,
        data.proofSize,
        data.timestamp || new Date().toISOString(),
        new Date().toISOString(),
        data.customInputs ? JSON.stringify(data.customInputs) : null,
        deviceInfo.platform,
        deviceInfo.device,
        deviceInfo.manufacturer || null,
        deviceInfo.deviceVersion || null,
        deviceId || null,
        deviceInfo.systemName || null,
        deviceInfo.systemVersion || null,
        deviceInfo.isPhysicalDevice ?? null,
        memory.totalPhysicalMemory || null,
        memory.memoryUsedBeforeProof || null,
        memory.peakMemoryUsage || null,
        memory.memoryConsumedByProof || null,
        memory.peakMemoryLoadInPercentage || null,
        memory.memoryConsumedInPercentage || null,
        battery.batteryBeforeProof || null,
        battery.batteryAfterProof || null,
        battery.batteryConsumed ?? null,
      ]
    );

    const insertedId = result.rows[0].id;
    logger.info(`Benchmark data saved successfully with ID: ${insertedId}`);

    res.status(201).json({
      success: true,
      message: 'Benchmark result received and saved successfully',
      documentId: insertedId.toString(),
      receivedAt: new Date().toISOString()
    });
  } catch (error) {
    logger.error('Error receiving benchmark result:', error);
    res.status(500).json({ error: error.message });
  }
};
