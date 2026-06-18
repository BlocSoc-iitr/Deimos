'use client'

import { useCallback, useEffect, useRef, useState } from 'react'
import type { ReactNode } from 'react'
import { Info } from 'lucide-react'

import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Popover, PopoverContent, PopoverTrigger } from '@/components/ui/popover'
import { cn } from '@/lib/utils'

// ─── InfoPopover ────────────────────────────────────────────────────────────

const HOVER_OPEN_DELAY = 200
const HOVER_CLOSE_DELAY = 300

interface InfoPopoverProps {
  children: ReactNode
  content: string
}

export function InfoPopover({ children, content }: InfoPopoverProps) {
  const [open, setOpen] = useState(false)
  const openTimer = useRef<ReturnType<typeof setTimeout> | null>(null)
  const closeTimer = useRef<ReturnType<typeof setTimeout> | null>(null)

  const clearTimers = useCallback(() => {
    if (openTimer.current) clearTimeout(openTimer.current)
    if (closeTimer.current) clearTimeout(closeTimer.current)
  }, [])

  // Clear any pending timeouts on unmount
  useEffect(() => clearTimers, [clearTimers])

  const handleEnter = useCallback(() => {
    clearTimers()
    openTimer.current = setTimeout(() => setOpen(true), HOVER_OPEN_DELAY)
  }, [clearTimers])

  const handleLeave = useCallback(() => {
    clearTimers()
    closeTimer.current = setTimeout(() => setOpen(false), HOVER_CLOSE_DELAY)
  }, [clearTimers])

  return (
    <Popover open={open} onOpenChange={setOpen}>
      <div onMouseEnter={handleEnter} onMouseLeave={handleLeave} className="flex items-center gap-1.5">
        <PopoverTrigger className="flex items-center gap-1.5 hover:opacity-75 transition-opacity">
          {children}
          <Info className="size-3.5 shrink-0 text-[#605A57]" />
        </PopoverTrigger>
      </div>
      <PopoverContent
        className="w-fit max-w-72 text-xs text-[#37322F]"
        onMouseEnter={handleEnter}
        onMouseLeave={handleLeave}
      >
        {content}
      </PopoverContent>
    </Popover>
  )
}

// ─── ChartCard ──────────────────────────────────────────────────────────────

interface ChartCardProps {
  title: string
  description: string
  children: ReactNode
  footer?: ReactNode
  className?: string
}

export function ChartCard({ title, description, children, footer, className }: ChartCardProps) {
  return (
    <Card className={cn('w-full border-[#E0DEDB] bg-white shadow-sm', className)}>
      <CardHeader className="pb-2">
        <div className="flex items-center">
          <InfoPopover content={description}>
            <CardTitle className="text-sm font-semibold text-[#37322F]">{title}</CardTitle>
          </InfoPopover>
        </div>
      </CardHeader>
      <CardContent>
        {children}
        {footer && <div className="mt-3">{footer}</div>}
      </CardContent>
    </Card>
  )
}

// ─── EmptyState ──────────────────────────────────────────────────────────────

export function EmptyState({ message }: { message: string }) {
  return (
    <div className="flex items-center justify-center py-12 text-sm text-[#605A57]">
      {message}
    </div>
  )
}

// ─── SeriesToggleLegend ──────────────────────────────────────────────────────

interface SeriesToggleLegendProps {
  provers: string[]
  hidden: Set<string>
  colorMap: Record<string, string>
  onToggle: (prover: string) => void
}

export function SeriesToggleLegend({ provers, hidden, colorMap, onToggle }: SeriesToggleLegendProps) {
  if (provers.length === 0) return null
  return (
    <div className="flex flex-wrap gap-2">
      {provers.map((prover) => {
        const isHidden = hidden.has(prover)
        return (
          <button
            key={prover}
            onClick={() => onToggle(prover)}
            className={cn(
              'flex items-center gap-1.5 rounded-md border px-2.5 py-1 text-xs font-medium transition-all',
              'border-[#E0DEDB] bg-white text-[#37322F] hover:bg-[#F7F5F3]',
              isHidden && 'opacity-40 line-through',
            )}
            aria-label={isHidden ? `Show ${prover}` : `Hide ${prover}`}
          >
            <span
              className="inline-block h-2.5 w-2.5 shrink-0 rounded-sm"
              style={{ backgroundColor: colorMap[prover] ?? '#999' }}
            />
            {prover}
          </button>
        )
      })}
    </div>
  )
}

// ─── ChartTooltipBody ────────────────────────────────────────────────────────

export interface TooltipEntry {
  name?: string | number
  value?: number | string | Array<number | string>
  color?: string
}

interface ChartTooltipBodyProps {
  label?: string
  entries: readonly TooltipEntry[]
  formatValue: (v: number) => string
}

export function ChartTooltipBody({ label, entries, formatValue }: ChartTooltipBodyProps) {
  const sorted = [...entries]
    .filter((e) => typeof e.value === 'number')
    .sort((a, b) => (b.value as number) - (a.value as number))

  if (sorted.length === 0) return null

  return (
    <div className="grid min-w-[8rem] gap-1.5 rounded-lg border border-[#E0DEDB] bg-white px-2.5 py-1.5 text-xs shadow-xl">
      {label && <p className="font-semibold text-[#37322F]">{label}</p>}
      {sorted.map((entry, i) => (
        <div key={i} className="flex w-full items-center gap-2">
          <span
            className="h-2.5 w-2.5 shrink-0 rounded-sm"
            style={{ backgroundColor: entry.color }}
          />
          <span className="flex-1 text-[#605A57]">{entry.name}</span>
          <span className="font-semibold tabular-nums text-[#37322F]">
            {typeof entry.value === 'number' ? formatValue(entry.value) : String(entry.value)}
          </span>
        </div>
      ))}
    </div>
  )
}
