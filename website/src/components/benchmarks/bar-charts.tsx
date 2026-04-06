'use client'

import { useCallback, useMemo } from 'react'
import { Bar, BarChart, Cell, Tooltip, XAxis, YAxis, type TooltipProps } from 'recharts'

import type { ChartConfig } from '@/components/ui/chart'
import { ChartContainer } from '@/components/ui/chart'
import type { BenchmarkData } from '@/app/types'

import { getProverKey, METRICS, type MetricConfig } from './metrics'
import { ChartCard, ChartTooltipBody, EmptyState } from './shared'

const BAR_HEIGHT = 48
const BAR_MIN_HEIGHT = 200
const BAR_MAX_HEIGHT = 520
const BAR_PADDING = 48
const BAR_FONT_SIZE = 11
const BAR_MARGIN = { top: 8, right: 90, left: 8, bottom: 8 }

function computeBarHeight(proverCount: number): number {
  return Math.min(Math.max(proverCount * BAR_HEIGHT + BAR_PADDING, BAR_MIN_HEIGHT), BAR_MAX_HEIGHT)
}

// ─── Custom label rendered at end of each bar ─────────────────────────────

interface CustomLabelProps {
  x?: number
  y?: number
  width?: number
  height?: number
  value?: number
  formatValue: (v: number) => string
}

function CustomBarLabel({ x = 0, y = 0, width = 0, height = 0, value = 0, formatValue }: CustomLabelProps) {
  return (
    <text
      x={x + width + 6}
      y={y + height / 2}
      fill="#37322F"
      fontSize={BAR_FONT_SIZE}
      textAnchor="start"
      dominantBaseline="middle"
    >
      {formatValue(value)}
    </text>
  )
}

// ─── Single metric bar chart ──────────────────────────────────────────────

interface BarEntry {
  prover: string
  value: number
  color: string
  isBest: boolean
}

interface SingleBarChartProps {
  metric: MetricConfig
  entries: BarEntry[]
  chartConfig: ChartConfig
}

function SingleBarChart({ metric, entries, chartConfig }: SingleBarChartProps) {
  const height = computeBarHeight(entries.length)

  const renderLabel = useCallback(
    (props: Record<string, unknown>) => (
      <CustomBarLabel
        x={props.x as number}
        y={props.y as number}
        width={props.width as number}
        height={props.height as number}
        value={props.value as number}
        formatValue={metric.formatValue}
      />
    ),
    [metric.formatValue],
  )

  const tooltipContent = useCallback(
    ({ active, payload }: TooltipProps<number, string>) => {
      if (!active || !payload || payload.length === 0) return null
      const item = payload[0]
      return (
        <ChartTooltipBody
          entries={[{ name: item.name ?? '', value: item.value, color: item.fill ?? '#999' }]}
          formatValue={metric.formatValue}
        />
      )
    },
    [metric.formatValue],
  )

  return (
    <ChartCard title={metric.label} description={metric.description}>
      <div style={{ height }} className="w-full transition-[height] duration-200">
        <ChartContainer config={chartConfig} className="h-full w-full">
          <BarChart
            accessibilityLayer
            data={entries}
            layout="vertical"
            margin={BAR_MARGIN}
          >
            <XAxis
              type="number"
              dataKey="value"
              hide
              domain={[0, (dataMax: number) => dataMax * 1.2]}
            />
            <YAxis
              type="category"
              dataKey="prover"
              width={130}
              tick={{ fontSize: BAR_FONT_SIZE, fill: '#605A57' }}
              tickLine={false}
              axisLine={false}
            />
            <Tooltip content={tooltipContent} cursor={{ fill: 'rgba(55,50,47,0.04)' }} />
            <Bar dataKey="value" radius={[0, 3, 3, 0]} label={renderLabel}>
              {entries.map((entry) => (
                <Cell
                  key={entry.prover}
                  fill={entry.color}
                  fillOpacity={entry.isBest ? 1 : 0.75}
                />
              ))}
            </Bar>
          </BarChart>
        </ChartContainer>
      </div>
    </ChartCard>
  )
}

// ─── BarCharts (public) ───────────────────────────────────────────────────

interface BarChartsProps {
  /** Already filtered to selectedFamily + selectedInputSize */
  data: BenchmarkData[]
  hiddenProvers: Set<string>
  colorMap: Record<string, string>
}

export function BarCharts({ data, hiddenProvers, colorMap }: BarChartsProps) {
  const chartConfig = useMemo<ChartConfig>(() => {
    return Object.fromEntries(
      Object.entries(colorMap).map(([key, color]) => [key, { label: key, color }]),
    )
  }, [colorMap])

  if (data.length === 0) {
    return <EmptyState message="No data available for the selected input size." />
  }

  return (
    <div className="grid grid-cols-1 gap-4 md:grid-cols-2">
      {METRICS.map((metric) => {
        // Aggregate: average metric value per prover (there may be multiple runs)
        const byProver = new Map<string, number[]>()
        for (const b of data) {
          const key = getProverKey(b)
          if (hiddenProvers.has(key)) continue
          const val = metric.getValue(b)
          if (val === null || val <= 0) continue
          if (!byProver.has(key)) byProver.set(key, [])
          byProver.get(key)!.push(val)
        }

        const entries: BarEntry[] = Array.from(byProver.entries())
          .map(([prover, values]) => ({
            prover,
            // Use median for robustness
            value: values.sort((a, b) => a - b)[Math.floor(values.length / 2)],
            color: colorMap[prover] ?? '#999',
            isBest: false,
          }))
          .sort((a, b) => a.value - b.value)

        if (entries.length === 0) return null

        // Mark the best (lowest) value
        entries[0].isBest = true

        return (
          <SingleBarChart
            key={metric.key}
            metric={metric}
            entries={entries}
            chartConfig={chartConfig}
          />
        )
      })}
    </div>
  )
}
