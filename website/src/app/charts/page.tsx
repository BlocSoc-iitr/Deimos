'use client';
import { useState, useEffect, useMemo, useCallback, useRef } from 'react';
import type { BenchmarkData } from '../types';
import {
  getDeviceKey,
  buildProverColorMap,
} from '@/components/benchmarks/metrics';
import { CircuitTabs } from '@/components/benchmarks/circuit-tabs';
import { SeriesToggleLegend } from '@/components/benchmarks/shared';
import { BarCharts } from '@/components/benchmarks/bar-charts';
import { LineCharts } from '@/components/benchmarks/line-charts';
import { cn } from '@/lib/utils';

const API_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:5000';

export default function ChartsPage() {
  const [circuits, setCircuits] = useState<string[]>([]);
  const [selectedFamily, setSelectedFamily] = useState<string>('');
  const [selectedInputSize, setSelectedInputSize] = useState<number>(0);
  const [selectedDevice, setSelectedDevice] = useState<string>('');
  const [selectedBackend, setSelectedBackend] = useState<string>('');
  const [deselectedDevices, setDeselectedDevices] = useState<Set<string>>(new Set());
  const [deviceDropdownOpen, setDeviceDropdownOpen] = useState(false);
  const deviceDropdownRef = useRef<HTMLDivElement>(null);
  const [hiddenProvers, setHiddenProvers] = useState<Set<string>>(new Set());
  const [chartData, setChartData] = useState<BenchmarkData[]>([]);
  const [chartLoading, setChartLoading] = useState<boolean>(false);

  const families = useMemo<string[]>(() => [...circuits].sort(), [circuits]);

  // All device keys present in the data
  const allDevices = useMemo<string[]>(
    () => [...new Set(chartData.map(getDeviceKey))].sort(),
    [chartData],
  );

  // Input unit derived from customInputs keys
  const inputUnit = useMemo<string>(() => {
    for (const b of chartData) {
      if (!b.customInputs) continue;
      const key = Object.keys(b.customInputs)[0];
      if (!key) continue;
      const match = key.match(/\d+([a-z]*)$/);
      if (!match) continue;
      const suffix = match[1];
      if (suffix === 'f') return 'field elements';
      if (suffix === 'm') return 'field elements'; // M31 count normalized to BN254-equivalent
      if (suffix === 'u') return 'bytes';          // U32 count normalized to bytes (* 4)
      return 'bytes';
    }
    return '';
  }, [chartData]);

  const inputSizesForFamily = useMemo<number[]>(
    () =>
      [...new Set(chartData.filter((b) => b.inputSize != null).map((b) => b.inputSize as number))]
        .sort((a, b) => a - b),
    [chartData],
  );

  // ─── Line charts: series = device, filtered by selected backend ──────────
  const allBackends = useMemo<string[]>(
    () => [...new Set(chartData.map((b) => b.language).filter(Boolean))].sort(),
    [chartData],
  );

  const lineData = useMemo<BenchmarkData[]>(
    () => chartData.filter((b) => {
      if (selectedBackend && b.language !== selectedBackend) return false;
      if (deselectedDevices.has(getDeviceKey(b))) return false;
      return true;
    }),
    [chartData, selectedBackend, deselectedDevices],
  );

  const lineColorMap = useMemo(() => {
    // Build color map from ALL devices (not just active), so colors stay stable
    const keys = [...new Set(chartData.map(getDeviceKey))].sort();
    return buildProverColorMap(keys);
  }, [chartData]);

  const lineProvers = useMemo<string[]>(() => Object.keys(lineColorMap).sort(), [lineColorMap]);

  // ─── Bar charts: series = backend, fixed device ───────────────────────────
  // Data filtered to selected device + selected input size
  const barData = useMemo<BenchmarkData[]>(
    () => {
      const byDevice = chartData.filter((b) => getDeviceKey(b) === selectedDevice);
      if (inputSizesForFamily.length === 0) return byDevice;
      return byDevice.filter((b) => b.inputSize === selectedInputSize);
    },
    [chartData, selectedDevice, selectedInputSize, inputSizesForFamily],
  );

  // series key for bar charts = backend (language)
  const backendKeyFn = useCallback((b: BenchmarkData) => b.language ?? 'unknown', []);

  const barKeys = useMemo<string[]>(
    () => [...new Set(barData.map(backendKeyFn))].sort(),
    [barData, backendKeyFn],
  );

  const barColorMap = useMemo(() => buildProverColorMap(barKeys), [barKeys]);

  const toggleProver = useCallback((prover: string) => {
    setHiddenProvers((prev) => {
      const next = new Set(prev);
      if (next.has(prover)) { next.delete(prover); } else { next.add(prover); }
      return next;
    });
  }, []);

  useEffect(() => {
    fetch(`${API_URL}/api/filters`)
      .then((r) => r.json())
      .then((data) => setCircuits((data.circuits ?? []).filter((c: string) => c !== 'all')))
      .catch(console.error);
  }, []);

  useEffect(() => {
    if (families.length > 0 && !selectedFamily) setSelectedFamily(families[0]);
  }, [families, selectedFamily]);

  useEffect(() => {
    if (allDevices.length > 0 && !allDevices.includes(selectedDevice)) {
      setSelectedDevice(allDevices[0]);
    }
  }, [allDevices, selectedDevice]);

  useEffect(() => {
    if (allBackends.length > 0 && !allBackends.includes(selectedBackend)) {
      setSelectedBackend(allBackends[0]);
    }
  }, [allBackends, selectedBackend]);

  useEffect(() => {
    if (inputSizesForFamily.length > 0) {
      const medianIdx = Math.floor(inputSizesForFamily.length / 2);
      setSelectedInputSize(inputSizesForFamily[medianIdx]);
    }
  }, [inputSizesForFamily]);

  // Reset deselected devices when circuit family changes
  useEffect(() => {
    setDeselectedDevices(new Set());
  }, [selectedFamily]);

  // Close dropdown on outside click
  useEffect(() => {
    function handleClick(e: MouseEvent) {
      if (deviceDropdownRef.current && !deviceDropdownRef.current.contains(e.target as Node)) {
        setDeviceDropdownOpen(false);
      }
    }
    document.addEventListener('mousedown', handleClick);
    return () => document.removeEventListener('mousedown', handleClick);
  }, []);

  useEffect(() => {
    if (!selectedFamily) return;
    let cancelled = false;
    setChartLoading(true);
    setChartData([]);
    fetch(`${API_URL}/api/benchmarks?circuit=${encodeURIComponent(selectedFamily)}&limit=500`)
      .then((r) => r.json())
      .then((r) => {
        if (!cancelled) {
          setChartData(Array.isArray(r.data) ? r.data as BenchmarkData[] : []);
          setChartLoading(false);
        }
      })
      .catch(() => { if (!cancelled) setChartLoading(false); });
    return () => { cancelled = true; };
  }, [selectedFamily]);

  return (
    <div className="min-h-screen bg-[#F7F5F3]">
      <section className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pb-6 pt-4">
        <div className="mb-6">
          <h1 className="text-xl font-semibold text-[#37322F]">Performance Charts</h1>
          <p className="mt-1 text-sm text-[#605A57]">Compare proving backends across circuits, input sizes, and devices.</p>
        </div>

        {families.length === 0 ? (
          <div className="rounded-lg border border-[#E0DEDB] bg-white p-8 text-center text-sm text-[#605A57]">
            Loading circuits…
          </div>
        ) : (
          <div className="space-y-5">
            {/* ── Selectors ─────────────────────────────────────────────── */}
            <div className="rounded-lg border border-[#E0DEDB] bg-white p-5 shadow-sm">
              <div className="flex items-center justify-between mb-4">
                <span className="text-sm font-semibold text-[#37322F]">Filters</span>
                {chartLoading && <span className="text-xs text-[#605A57]">Loading…</span>}
              </div>
              <CircuitTabs
                families={families}
                selectedFamily={selectedFamily}
                onFamilyChange={(f) => { setSelectedFamily(f); setHiddenProvers(new Set()); }}
                languages={[]}
                selectedLanguage=""
                onLanguageChange={() => {}}
                inputSizes={inputSizesForFamily}
                selectedInputSize={selectedInputSize}
                onInputSizeChange={setSelectedInputSize}
                unit={inputUnit}
              />
            </div>

            {!chartLoading && chartData.length > 0 && (
              <>
                {/* ── Bar charts: backends for a fixed device ───────────── */}
                <div className="rounded-lg border border-[#E0DEDB] bg-white p-5 shadow-sm space-y-4">
                  <div className="flex flex-wrap items-center justify-between gap-3">
                    <div>
                      <h2 className="text-sm font-semibold text-[#37322F]">
                        Backend Comparison
                      </h2>
                      <p className="text-xs text-[#605A57] mt-0.5">
                        {inputSizesForFamily.length === 0 ? 'All input sizes' : `At ${selectedInputSize}${inputUnit ? ` ${inputUnit}` : ''}`}
                        {' · '}fixed device
                      </p>
                    </div>
                    {/* Device selector */}
                    {allDevices.length > 1 && (
                      <div className="flex flex-wrap items-center gap-2">
                        <span className="text-xs text-[#605A57]">Device:</span>
                        {allDevices.map((d) => (
                          <button
                            key={d}
                            onClick={() => setSelectedDevice(d)}
                            className={cn(
                              'rounded border px-2.5 py-0.5 text-xs font-medium transition-colors',
                              selectedDevice === d
                                ? 'border-[#37322F] bg-[#37322F] text-white'
                                : 'border-[#E0DEDB] bg-white text-[#37322F] hover:bg-[#F7F5F3]',
                            )}
                          >
                            {d}
                          </button>
                        ))}
                      </div>
                    )}
                  </div>
                  <BarCharts
                    data={barData}
                    hiddenProvers={hiddenProvers}
                    colorMap={barColorMap}
                    seriesKeyFn={backendKeyFn}
                  />
                </div>

                {/* ── Line charts: devices across input sizes, fixed backend ── */}
                {inputSizesForFamily.length > 1 && (
                  <div className="rounded-lg border border-[#E0DEDB] bg-white p-5 shadow-sm space-y-4">
                    <div className="space-y-3">
                      <div className="flex flex-wrap items-center justify-between gap-3">
                        <div>
                          <h2 className="text-sm font-semibold text-[#37322F]">Trends Across Input Sizes</h2>
                          <p className="text-xs text-[#605A57] mt-0.5">Each line = device · fixed backend</p>
                        </div>
                        {allBackends.length > 1 && (
                          <div className="flex flex-wrap items-center gap-2">
                            <span className="text-xs text-[#605A57]">Backend:</span>
                            {allBackends.map((b) => (
                              <button
                                key={b}
                                onClick={() => setSelectedBackend(b)}
                                className={cn(
                                  'rounded border px-2.5 py-0.5 text-xs font-medium transition-colors',
                                  selectedBackend === b
                                    ? 'border-[#37322F] bg-[#37322F] text-white'
                                    : 'border-[#E0DEDB] bg-white text-[#37322F] hover:bg-[#F7F5F3]',
                                )}
                              >
                                {b}
                              </button>
                            ))}
                          </div>
                        )}
                      </div>
                      {/* Device multi-select dropdown — below the title row, left-aligned */}
                      {allDevices.length > 1 && (
                          <div className="relative" ref={deviceDropdownRef}>
                            <button
                              onClick={() => setDeviceDropdownOpen((o) => !o)}
                              className="flex items-center gap-1.5 rounded border border-[#E0DEDB] bg-white px-3 py-1 text-xs font-medium text-[#37322F] hover:bg-[#F7F5F3] transition-colors"
                            >
                              Devices
                              {deselectedDevices.size > 0 && (
                                <span className="rounded-full bg-[#37322F] text-white px-1.5 py-0 text-[10px] leading-4">
                                  {allDevices.length - deselectedDevices.size}/{allDevices.length}
                                </span>
                              )}
                              <svg className={cn('w-3 h-3 transition-transform', deviceDropdownOpen && 'rotate-180')} fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
                              </svg>
                            </button>
                            {deviceDropdownOpen && (
                              <div className="absolute left-0 top-full mt-1 z-20 min-w-[200px] rounded-lg border border-[#E0DEDB] bg-white shadow-lg py-1">
                                <button
                                  onClick={() => setDeselectedDevices(new Set())}
                                  className="w-full px-3 py-1.5 text-left text-xs text-[#605A57] hover:bg-[#F7F5F3] border-b border-[#E0DEDB]"
                                >
                                  Select all
                                </button>
                                {allDevices.map((d) => {
                                  const checked = !deselectedDevices.has(d);
                                  return (
                                    <label key={d} className="flex items-center gap-2 px-3 py-1.5 text-xs text-[#37322F] hover:bg-[#F7F5F3] cursor-pointer">
                                      <input
                                        type="checkbox"
                                        checked={checked}
                                        onChange={() => {
                                          setDeselectedDevices((prev) => {
                                            const next = new Set(prev);
                                            if (next.has(d)) { next.delete(d); } else { next.add(d); }
                                            return next;
                                          });
                                        }}
                                        className="rounded"
                                      />
                                      <span
                                        className="inline-block w-2 h-2 rounded-full flex-shrink-0"
                                        style={{ backgroundColor: lineColorMap[d] ?? '#999' }}
                                      />
                                      {d}
                                    </label>
                                  );
                                })}
                              </div>
                            )}
                          </div>
                        )}
                    </div>
                    <LineCharts
                      data={lineData}
                      hiddenProvers={hiddenProvers}
                      colorMap={lineColorMap}
                      onToggle={toggleProver}
                      unit={inputUnit}
                      seriesKeyFn={getDeviceKey}
                    />
                  </div>
                )}
              </>
            )}
          </div>
        )}
      </section>
    </div>
  );
}
