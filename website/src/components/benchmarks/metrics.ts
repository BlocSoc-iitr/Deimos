import type { BenchmarkData } from '@/app/types'

// ─── Prover key ─────────────────────────────────────────────────────────────

/** The unit of comparison — one "line" per prover key in charts. */
export function getProverKey(b: BenchmarkData): string {
  const device = b.deviceInfo?.device ?? 'Unknown'
  const platform = b.deviceInfo?.platform ?? ''
  const backend = b.language ?? ''
  const deviceStr = platform ? `${device} (${platform})` : device
  return backend ? `${deviceStr} / ${backend}` : deviceStr
}

export function getDeviceKey(b: BenchmarkData): string {
  const device = b.deviceInfo?.device ?? 'Unknown'
  const platform = b.deviceInfo?.platform ?? ''
  return platform ? `${device} (${platform})` : device
}

// ─── Color palette ──────────────────────────────────────────────────────────

export const PROVER_COLORS: readonly string[] = [
  '#6366f1', // indigo
  '#f59e0b', // amber
  '#10b981', // emerald
  '#ef4444', // red
  '#8b5cf6', // violet
  '#06b6d4', // cyan
  '#f97316', // orange
  '#84cc16', // lime
  '#ec4899', // pink
  '#14b8a6', // teal
]

/**
 * Builds a stable color map from a sorted list of prover names.
 * Sorting ensures consistent color assignment regardless of insertion order.
 */
export function buildProverColorMap(provers: string[]): Record<string, string> {
  return [...provers].sort().reduce<Record<string, string>>((acc, name, i) => {
    acc[name] = PROVER_COLORS[i % PROVER_COLORS.length]
    return acc
  }, {})
}

// ─── Metric configuration ────────────────────────────────────────────────────

export type MetricKey = 'proving_time' | 'verify_time' | 'peak_memory' | 'proof_size'

export interface MetricConfig {
  key: MetricKey
  label: string
  description: string
  getValue: (b: BenchmarkData) => number | null
  formatValue: (raw: number) => string
  /** Whether to use a log scale on the Y-axis for line charts */
  logScale: boolean
}

function formatDuration(ms: number): string {
  if (ms >= 60_000) return `${(ms / 60_000).toFixed(1)}m`
  if (ms >= 1_000) return `${(ms / 1_000).toFixed(2)}s`
  return `${ms.toFixed(0)}ms`
}

function formatBytes(bytes: number): string {
  if (bytes >= 1_073_741_824) return `${(bytes / 1_073_741_824).toFixed(2)} GB`
  if (bytes >= 1_048_576) return `${(bytes / 1_048_576).toFixed(1)} MB`
  if (bytes >= 1_024) return `${(bytes / 1_024).toFixed(0)} KB`
  return `${bytes} B`
}

export const METRICS: MetricConfig[] = [
  {
    key: 'proving_time',
    label: 'Proving Time',
    description: 'Time taken to generate the zero-knowledge proof on-device (lower is better).',
    getValue: (b) => (b.provingTimeMiliSeconds > 0 ? b.provingTimeMiliSeconds : null),
    formatValue: formatDuration,
    logScale: true,
  },
  {
    key: 'verify_time',
    label: 'Verification Time',
    description: 'Time taken to verify the proof on-device (lower is better).',
    getValue: (b) => (b.verificationTimeMiliSeconds > 0 ? b.verificationTimeMiliSeconds : null),
    formatValue: formatDuration,
    logScale: true,
  },
  {
    key: 'peak_memory',
    label: 'Memory Consumed',
    description: 'RAM consumed by proof generation (lower is better).',
    getValue: (b) => b.deviceInfo?.memory?.memoryConsumedByProof ?? null,
    formatValue: formatBytes,
    logScale: false,
  },
]
