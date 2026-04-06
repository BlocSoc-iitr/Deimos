'use client'

import { useCallback, useMemo } from 'react'
import { CartesianGrid, Line, LineChart, Tooltip, XAxis, YAxis, type TooltipProps } from 'recharts'

import type { ChartConfig } from '@/components/ui/chart'
import { ChartContainer } from '@/components/ui/chart'
import type { BenchmarkData } from '@/app/types'

import { getProverKey, METRICS, type MetricConfig } from './metrics'
import { ChartCard, ChartTooltipBody, EmptyState, SeriesToggleLegend } from './shared'

const LINE_MARGIN = { top: 20, right: 20, left: 20, bottom: 20 }
const AXIS_TICK_STYLE = { fontSize: 11, fill: '#605A57' }

// ─── Y-axis tick generation for log scale ────────────────────────────────

function generateLogTicks(min: number, max: number, isTime: boolean): number[] {
  if (min <= 0 || max <= 0 || min === max) return []

  const ms = 1
  const sec = 1_000
  const min_ = 60_000
  const kb = 1_024
  const mb = kb * 1_024
  const gb = mb * 1_024

  const magnitudes = isTime
    ? [1, 10, 100, ms, 10, 100, sec, 10 * sec, 60 * sec, min_]
    : [1, kb, 10 * kb, 100 * kb, mb, 10 * mb, 100 * mb, gb]

  const valid = magnitudes.filter((m) => m > 0 && m >= min * 0.5 && m <= max * 2)
  if (valid.length === 0) return [min, max]
  return valid
}

// ─── Single metric line chart ─────────────────────────────────────────────

interface LineDataPoint {
  inputSize: number
  [proverKey: string]: number | null
}

interface SingleLineChartProps {
  metric: MetricConfig
  data: LineDataPoint[]
  seriesKeys: string[]
  chartConfig: ChartConfig
  hiddenProvers: Set<string>
  onToggle: (key: string) => void
  unit: string
}

function SingleLineChart({
  metric,
  data,
  seriesKeys,
  chartConfig,
  hiddenProvers,
  onToggle,
  unit,
}: SingleLineChartProps) {
  const allValues = useMemo(() => {
    const vals: number[] = []
    for (const point of data) {
      for (const key of seriesKeys) {
        const v = point[key]
        if (typeof v === 'number' && v > 0) vals.push(v)
      }
    }
    return vals
  }, [data, seriesKeys])

  const ticks = useMemo(() => {
    if (allValues.length === 0) return undefined
    const min = Math.min(...allValues)
    const max = Math.max(...allValues)
    return metric.logScale ? generateLogTicks(min, max, metric.key === 'proving_time' || metric.key === 'verify_time') : undefined
  }, [allValues, metric])

  const xTickFormatter = useCallback(
    (v: unknown) => (typeof v === 'number' ? `${v} ${unit}` : String(v)),
    [unit],
  )

  const yTickFormatter = useCallback(
    (v: unknown) => (typeof v === 'number' ? metric.formatValue(v) : String(v)),
    [metric],
  )

  const tooltipContent = useCallback(
    ({
      active,
      payload,
      label,
  }: TooltipProps<number, string>) => {
      if (!active || !payload || payload.length === 0) return null
      return (
        <ChartTooltipBody
          label={label !== undefined ? `${label} ${unit}` : undefined}
          entries={payload.map((p) => ({ name: p.name ?? '', value: p.value, color: p.stroke ?? p.fill ?? '#999' }))}
          formatValue={metric.formatValue}
        />
      )
    },
    [metric, unit],
  )

  const legend = (
    <SeriesToggleLegend
      provers={seriesKeys}
      hidden={hiddenProvers}
      colorMap={Object.fromEntries(seriesKeys.map((k) => [k, chartConfig[k]?.color ?? '#999']))}
      onToggle={onToggle}
    />
  )

  return (
    <ChartCard title={metric.label} description={metric.description} footer={legend}>
      <ChartContainer config={chartConfig} className="h-[280px] w-full md:h-[340px]">
        <LineChart accessibilityLayer data={data} margin={LINE_MARGIN}>
          <CartesianGrid strokeDasharray="3 3" stroke="rgba(55,50,47,0.08)" />
          <XAxis
            dataKey="inputSize"
            tick={AXIS_TICK_STYLE}
            tickLine={false}
            tickMargin={6}
            tickFormatter={xTickFormatter}
          />
          <YAxis
            scale={metric.logScale ? 'log' : 'auto'}
            domain={metric.logScale ? (['auto', 'auto'] as [string, string]) : undefined}
            ticks={ticks}
            tick={AXIS_TICK_STYLE}
            tickLine={false}
            tickMargin={6}
            tickFormatter={yTickFormatter}
            width={64}
          />
          <Tooltip cursor={{ strokeDasharray: '3 3' }} content={tooltipContent} />
          {seriesKeys.map((key) => (
            <Line
              key={key}
              type="monotone"
              dataKey={key}
              stroke={chartConfig[key]?.color}
              dot={{ r: 3 }}
              activeDot={{ r: 5 }}
              strokeWidth={2}
              hide={hiddenProvers.has(key)}
              connectNulls={false}
              isAnimationActive={false}
            />
          ))}
        </LineChart>
      </ChartContainer>
    </ChartCard>
  )
}

// ─── LineCharts (public) ──────────────────────────────────────────────────

interface LineChartsProps {
  /** All data for the selected family — all input sizes */
  data: BenchmarkData[]
  hiddenProvers: Set<string>
  colorMap: Record<string, string>
  onToggle: (prover: string) => void
  unit: string
}

export function LineCharts({ data, hiddenProvers, colorMap, onToggle, unit }: LineChartsProps) {
  const seriesKeys = useMemo(
    () => [...new Set(data.map(getProverKey))].sort(),
    [data],
  )

  const chartConfig = useMemo<ChartConfig>(
    () =>
      Object.fromEntries(
        seriesKeys.map((key) => [key, { label: key, color: colorMap[key] ?? '#999' }]),
      ),
    [seriesKeys, colorMap],
  )

  // Build one data array per metric, indexed by inputSize
  const metricsData = useMemo(() => {
    return METRICS.map((metric) => {
      // group by inputSize → proverKey → values[]
      const grouped = new Map<number, Map<string, number[]>>()
      for (const b of data) {
        if (b.inputSize == null) continue
        const key = getProverKey(b)
        const val = metric.getValue(b)
        if (val === null || val <= 0) continue

        const inputSize = b.inputSize
        if (!grouped.has(inputSize)) grouped.set(inputSize, new Map())
        const sizeMap = grouped.get(inputSize)!
        if (!sizeMap.has(key)) sizeMap.set(key, [])
        sizeMap.get(key)!.push(val)
      }

      const points: LineDataPoint[] = Array.from(grouped.entries())
        .sort(([a], [b]) => a - b)
        .map(([inputSize, proverMap]) => {
          const point: LineDataPoint = { inputSize }
          for (const key of seriesKeys) {
            const vals = proverMap.get(key)
            if (vals && vals.length > 0) {
              const sorted = [...vals].sort((a, b) => a - b)
              // median
              point[key] = sorted[Math.floor(sorted.length / 2)]
            } else {
              point[key] = null
            }
          }
          return point
        })

      return { metric, points }
    })
  }, [data, seriesKeys])

  if (data.length === 0) {
    return <EmptyState message="No data available for this circuit family." />
  }

  const inputSizeCount = new Set(
    data.map((b) => b.inputSize).filter((s) => s != null),
  ).size

  if (inputSizeCount <= 1) {
    return (
      <EmptyState message="Trends require data across multiple input sizes — only one size is available." />
    )
  }

  return (
    <div className="grid grid-cols-1 gap-4 md:grid-cols-2">
      {metricsData.map(({ metric, points }) => (
        <SingleLineChart
          key={metric.key}
          metric={metric}
          data={points}
          seriesKeys={seriesKeys}
          chartConfig={chartConfig}
          hiddenProvers={hiddenProvers}
          onToggle={onToggle}
          unit={unit}
        />
      ))}
    </div>
  )
}
