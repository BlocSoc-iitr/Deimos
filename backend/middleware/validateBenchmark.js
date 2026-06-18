// Server-side validation for incoming benchmark payloads. Rejects malformed /
// out-of-range data before it ever reaches the database. Lenient enough that any
// genuine app payload passes, strict enough to drop junk.

const LIMITS = {
  str: 100, // circuit / framework / language / device / manufacturer
  id: 200, // deviceId
  shortStr: 50, // platform / systemVersion
  timeMs: 3_600_000, // 1 hour
  bytes: 2_000_000_000, // ~2 GB
  inputSize: 100_000_000,
  cpuMs: 3_600_000,
  cpuPercent: 6_400, // up to ~64 cores at 100%
  pct: 1_000,
};

const isNum = (v) => typeof v === 'number' && Number.isFinite(v);
const isObj = (v) => v != null && typeof v === 'object' && !Array.isArray(v);

function num(errors, name, v, { min = 0, max, required = true, integer = false } = {}) {
  if (v == null) {
    if (required) errors.push(`${name} is required`);
    return;
  }
  if (!isNum(v)) return errors.push(`${name} must be a number`);
  if (integer && !Number.isInteger(v)) errors.push(`${name} must be an integer`);
  if (min != null && v < min) errors.push(`${name} must be >= ${min}`);
  if (max != null && v > max) errors.push(`${name} must be <= ${max}`);
}

function str(errors, name, v, { maxLen, required = true } = {}) {
  if (v == null) {
    if (required) errors.push(`${name} is required`);
    return;
  }
  if (typeof v !== 'string') return errors.push(`${name} must be a string`);
  if (v.length === 0) errors.push(`${name} must not be empty`);
  if (maxLen && v.length > maxLen) errors.push(`${name} exceeds ${maxLen} chars`);
}

/**
 * Validates one benchmark object. Returns an array of error strings
 * (empty array = valid).
 */
export function validateBenchmark(data) {
  const e = [];
  if (!isObj(data)) return ['payload must be a JSON object'];

  str(e, 'circuit', data.circuit, { maxLen: LIMITS.str });
  str(e, 'framework', data.framework, { maxLen: LIMITS.str });
  str(e, 'language', data.language, { maxLen: LIMITS.str });
  num(e, 'provingTimeMiliSeconds', data.provingTimeMiliSeconds, { max: LIMITS.timeMs, integer: true });
  num(e, 'verificationTimeMiliSeconds', data.verificationTimeMiliSeconds, { max: LIMITS.timeMs, integer: true });
  num(e, 'proofSize', data.proofSize, { max: LIMITS.bytes, integer: true });
  if (data.inputSize != null) num(e, 'inputSize', data.inputSize, { max: LIMITS.inputSize, integer: true });
  if (data.timestamp != null && (typeof data.timestamp !== 'string' || Number.isNaN(Date.parse(data.timestamp)))) {
    e.push('timestamp must be an ISO date string');
  }
  if (data.customInputs != null && !isObj(data.customInputs)) e.push('customInputs must be an object');

  const di = data.deviceInfo;
  if (!isObj(di)) {
    e.push('deviceInfo is required');
    return e;
  }
  str(e, 'deviceInfo.platform', di.platform, { maxLen: LIMITS.shortStr });
  str(e, 'deviceInfo.device', di.device, { maxLen: LIMITS.str });
  str(e, 'deviceInfo.manufacturer', di.manufacturer, { maxLen: LIMITS.str, required: false });
  str(e, 'deviceInfo.deviceId', di.deviceId, { maxLen: LIMITS.id, required: false });
  str(e, 'deviceInfo.systemVersion', di.systemVersion, { maxLen: LIMITS.shortStr, required: false });

  if (di.memory != null) {
    const m = di.memory;
    if (!isObj(m)) e.push('deviceInfo.memory must be an object');
    else {
      num(e, 'memory.totalPhysicalMemory', m.totalPhysicalMemory, { max: LIMITS.bytes, required: false });
      num(e, 'memory.memoryUsedBeforeProof', m.memoryUsedBeforeProof, { max: LIMITS.bytes, required: false });
      num(e, 'memory.peakMemoryUsage', m.peakMemoryUsage, { max: LIMITS.bytes, required: false });
      num(e, 'memory.memoryConsumedByProof', m.memoryConsumedByProof, { min: null, max: LIMITS.bytes, required: false });
      num(e, 'memory.peakMemoryLoadInPercentage', m.peakMemoryLoadInPercentage, { max: LIMITS.pct, required: false });
      num(e, 'memory.memoryConsumedInPercentage', m.memoryConsumedInPercentage, { min: null, max: LIMITS.pct, required: false });
    }
  }
  if (di.cpu != null) {
    const c = di.cpu;
    if (!isObj(c)) e.push('deviceInfo.cpu must be an object');
    else {
      num(e, 'cpu.cpuTimeMs', c.cpuTimeMs, { max: LIMITS.cpuMs, required: false });
      num(e, 'cpu.cpuPercent', c.cpuPercent, { max: LIMITS.cpuPercent, required: false });
    }
  }
  return e;
}
