-- Deimos Benchmark Database Schema

CREATE TABLE IF NOT EXISTS benchmarks (
  id SERIAL PRIMARY KEY,

  -- Benchmark metadata
  circuit VARCHAR(100) NOT NULL,
  framework VARCHAR(100) NOT NULL,
  language VARCHAR(100) NOT NULL,
  proving_time_ms INTEGER NOT NULL,
  verification_time_ms INTEGER NOT NULL,
  proof_size INTEGER NOT NULL,
  timestamp TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  custom_inputs JSONB,

  -- Device info
  platform VARCHAR(20) NOT NULL,
  device VARCHAR(100) NOT NULL,
  manufacturer VARCHAR(100),
  device_version VARCHAR(20), -- basically model_code => Galaxy A52 → SM-A525F
  device_id VARCHAR(100), -- the unique identifier
  system_name VARCHAR(50),
  system_version VARCHAR(20),
  is_physical_device BOOLEAN,

  -- Memory info
  total_physical_memory BIGINT,
  memory_used_before_proof BIGINT,
  peak_memory_usage BIGINT,
  memory_consumed_by_proof BIGINT,
  peak_memory_load_percentage DECIMAL(5,2),
  memory_consumed_percentage DECIMAL(5,2),

  -- Battery info
  battery_before_proof SMALLINT,
  battery_after_proof SMALLINT,
  battery_consumed SMALLINT
);

-- Indexes for common filter queries
CREATE INDEX IF NOT EXISTS idx_benchmarks_circuit ON benchmarks(circuit);
CREATE INDEX IF NOT EXISTS idx_benchmarks_framework ON benchmarks(framework);
CREATE INDEX IF NOT EXISTS idx_benchmarks_language ON benchmarks(language);
CREATE INDEX IF NOT EXISTS idx_benchmarks_platform ON benchmarks(platform);
CREATE INDEX IF NOT EXISTS idx_benchmarks_timestamp ON benchmarks(timestamp DESC);

-- Composite index for duplicate detection
CREATE INDEX IF NOT EXISTS idx_benchmarks_duplicate_check
  ON benchmarks(device_id, circuit, framework, language)
  WHERE device_id IS NOT NULL;
