-- Deimos Benchmark Database Schema

CREATE TABLE IF NOT EXISTS benchmarks (
  id SERIAL PRIMARY KEY,

  -- Benchmark metadata
  circuit VARCHAR(100) NOT NULL,
  framework VARCHAR(100) NOT NULL,
  language VARCHAR(100) NOT NULL,
  input_size INTEGER,
  proving_time_ms INTEGER NOT NULL,
  verification_time_ms INTEGER NOT NULL,
  proof_size INTEGER NOT NULL,
  preprocessing_size BIGINT,  -- prover artifact size (zkey / SRS+circuit / program)
  timestamp TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  custom_inputs JSONB,

  -- Device info
  platform VARCHAR(20) NOT NULL,
  device VARCHAR(100) NOT NULL,         -- device/model name, e.g. SM-A525F / iPhone 13
  manufacturer VARCHAR(100),
  device_id VARCHAR(100),               -- the unique identifier
  system_version VARCHAR(20),           -- OS version

  -- Memory info (process-level)
  total_physical_memory BIGINT,
  peak_memory_usage BIGINT,
  peak_memory_load_percentage DECIMAL(5,2),

  -- CPU info
  cpu_time_ms INTEGER,                  -- process CPU time consumed by proving
  cpu_percent DECIMAL(7,2),            -- avg CPU utilisation (>100% = multi-core)

  -- Thermal (battery temperature at run time, °C; proxy for device thermal state)
  temperature_c DECIMAL(5,2),

  -- How many uploads have been averaged into this row. Re-uploading the same
  -- (device, circuit, framework, language, input_size) folds the new metrics
  -- into a running mean instead of being rejected as a duplicate.
  sample_count INTEGER NOT NULL DEFAULT 1
);

-- Migrations for existing databases (CREATE TABLE above only applies to new ones)
ALTER TABLE benchmarks ADD COLUMN IF NOT EXISTS input_size INTEGER;
ALTER TABLE benchmarks ADD COLUMN IF NOT EXISTS preprocessing_size BIGINT;
ALTER TABLE benchmarks ADD COLUMN IF NOT EXISTS temperature_c DECIMAL(5,2);
ALTER TABLE benchmarks ADD COLUMN IF NOT EXISTS sample_count INTEGER NOT NULL DEFAULT 1;

-- Indexes for common filter queries
CREATE INDEX IF NOT EXISTS idx_benchmarks_circuit ON benchmarks(circuit);
CREATE INDEX IF NOT EXISTS idx_benchmarks_framework ON benchmarks(framework);
CREATE INDEX IF NOT EXISTS idx_benchmarks_language ON benchmarks(language);
CREATE INDEX IF NOT EXISTS idx_benchmarks_platform ON benchmarks(platform);
CREATE INDEX IF NOT EXISTS idx_benchmarks_timestamp ON benchmarks(timestamp DESC);

-- Unique index for duplicate detection + ON CONFLICT target.
-- Partial (only rows with a device_id) and NULLS NOT DISTINCT so a NULL
-- input_size is treated as a single value rather than always-distinct.
DROP INDEX IF EXISTS idx_benchmarks_duplicate_check;
CREATE UNIQUE INDEX IF NOT EXISTS idx_benchmarks_duplicate_check
  ON benchmarks(device_id, circuit, framework, language, input_size)
  NULLS NOT DISTINCT
  WHERE device_id IS NOT NULL;
