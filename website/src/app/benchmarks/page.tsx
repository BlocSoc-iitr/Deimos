'use client';
import React, { useState, useEffect } from 'react';
import type { BenchmarkData } from '../types';

const API_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:5000';

export default function BenchmarksPage() {
  const [filterCircuit, setFilterCircuit] = useState<string>('all');
  const [filterFramework, setFilterFramework] = useState<string>('all');
  const [filterLanguage, setFilterLanguage] = useState<string>('all');
  const [filterPlatform, setFilterPlatform] = useState<string>('all');
  const [currentPage, setCurrentPage] = useState<number>(1);
  const [itemsPerPage, setItemsPerPage] = useState<number>(10);

  const [benchmarkData, setBenchmarkData] = useState<BenchmarkData[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);
  const [totalPages, setTotalPages] = useState<number>(0);
  const [totalCount, setTotalCount] = useState<number>(0);
  const [expandedRows, setExpandedRows] = useState<Set<string>>(new Set());

  const [circuits, setCircuits] = useState<string[]>(['all']);
  const [frameworks, setFrameworks] = useState<string[]>(['all']);
  const [languages, setLanguages] = useState<string[]>(['all']);
  const [platforms, setPlatforms] = useState<string[]>(['all']);

  // Fetch filter options
  useEffect(() => {
    const fetchFilters = async () => {
      try {
        const response = await fetch(`${API_URL}/api/filters`);
        if (!response.ok) {
          throw new Error('Failed to fetch filters');
        }
        const data = await response.json();
        setCircuits(data.circuits);
        setFrameworks(data.frameworks);
        setLanguages(data.languages);
        setPlatforms(data.platforms);
      } catch (err) {
        console.error('Error fetching filters:', err);
      }
    };
    fetchFilters();
  }, []);

  // Fetch benchmark data
  useEffect(() => {
    const fetchData = async () => {
      setLoading(true);
      setError(null);

      try {
        const params = new URLSearchParams({
          circuit: filterCircuit,
          framework: filterFramework,
          language: filterLanguage,
          platform: filterPlatform,
          page: currentPage.toString(),
          limit: itemsPerPage.toString()
        });

        const response = await fetch(`${API_URL}/api/benchmarks?${params}`);

        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }

        const result = await response.json();
        setBenchmarkData(result.data);
        setTotalPages(result.pagination.totalPages);
        setTotalCount(result.pagination.totalCount);
      } catch (err) {
        setError(err instanceof Error ? err.message : 'An error occurred');
        setBenchmarkData([]);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, [filterCircuit, filterFramework, filterLanguage, filterPlatform, currentPage, itemsPerPage]);

  // Reset to page 1 when filters change
  const handleFilterChange = (setter: (value: string) => void, value: string) => {
    setter(value);
    setCurrentPage(1);
  };

  // Reset to page 1 when items per page changes
  const handleItemsPerPageChange = (value: number) => {
    setItemsPerPage(value);
    setCurrentPage(1);
  };

  // Generate page numbers to display
  const getPageNumbers = () => {
    const pages: (number | string)[] = [];
    const maxPagesToShow = 5;

    if (totalPages <= maxPagesToShow) {
      for (let i = 1; i <= totalPages; i++) {
        pages.push(i);
      }
    } else {
      if (currentPage <= 3) {
        for (let i = 1; i <= 4; i++) {
          pages.push(i);
        }
        pages.push('...');
        pages.push(totalPages);
      } else if (currentPage >= totalPages - 2) {
        pages.push(1);
        pages.push('...');
        for (let i = totalPages - 3; i <= totalPages; i++) {
          pages.push(i);
        }
      } else {
        pages.push(1);
        pages.push('...');
        pages.push(currentPage - 1);
        pages.push(currentPage);
        pages.push(currentPage + 1);
        pages.push('...');
        pages.push(totalPages);
      }
    }
    return pages;
  };

  const toggleRow = (id: string) => {
    const newExpanded = new Set(expandedRows);
    if (newExpanded.has(id)) {
      newExpanded.delete(id);
    } else {
      newExpanded.add(id);
    }
    setExpandedRows(newExpanded);
  };

  const formatBytes = (bytes: number) => {
    if (bytes === 0) return '0 Bytes';
    const k = 1024;
    const sizes = ['Bytes', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return Math.round((bytes / Math.pow(k, i)) * 100) / 100 + ' ' + sizes[i];
  };

  const formatTimestamp = (timestamp: string) => {
    const date = new Date(timestamp);
    const day = date.getDate();
    const month = date.toLocaleString('en-US', { month: 'long' });
    const year = date.getFullYear();
    const time = date.toLocaleTimeString('en-US', {
      hour: '2-digit',
      minute: '2-digit',
      hour12: true
    });
    return `${day} ${month} ${year}, ${time}`;
  };

  return (
    <div className="min-h-screen bg-[#F7F5F3]">
      {/* Hero Section */}
      <section className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pb-6 pt-4">







        {/* Filters */}
        <div className="mb-4 bg-white rounded-lg shadow-sm p-4 border border-[#E0DEDB]">
          <div className="flex flex-wrap gap-3">
            <div className="flex-1 min-w-[180px]">
              <select
                value={filterCircuit}
                onChange={(e) => handleFilterChange(setFilterCircuit, e.target.value)}
                className="w-full px-4 py-2 text-sm border border-[#E0DEDB] rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent bg-white transition-all"
              >
                {circuits.map(circuit => (
                  <option key={circuit} value={circuit}>
                    {circuit === 'all' ? 'All Circuits' : circuit}
                  </option>
                ))}
              </select>
            </div>

            <div className="flex-1 min-w-[180px]">
              <select
                value={filterFramework}
                onChange={(e) => handleFilterChange(setFilterFramework, e.target.value)}
                className="w-full px-4 py-2 text-sm border border-[#E0DEDB] rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent bg-white transition-all"
              >
                {frameworks.map(framework => (
                  <option key={framework} value={framework}>
                    {framework === 'all' ? 'All Frameworks' : framework}
                  </option>
                ))}
              </select>
            </div>

            <div className="flex-1 min-w-[180px]">
              <select
                value={filterLanguage}
                onChange={(e) => handleFilterChange(setFilterLanguage, e.target.value)}
                className="w-full px-4 py-2 text-sm border border-[#E0DEDB] rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent bg-white transition-all"
              >
                {languages.map(language => (
                  <option key={language} value={language}>
                    {language === 'all' ? 'All Languages' : language}
                  </option>
                ))}
              </select>
            </div>

            <div className="flex-1 min-w-[180px]">
              <select
                value={filterPlatform}
                onChange={(e) => handleFilterChange(setFilterPlatform, e.target.value)}
                className="w-full px-4 py-2 text-sm border border-[#E0DEDB] rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent bg-white transition-all"
              >
                {platforms.map(platform => (
                  <option key={platform} value={platform}>
                    {platform === 'all' ? 'All Platforms' : platform}
                  </option>
                ))}
              </select>
            </div>
          </div>
        </div>

        {/* Benchmark Table */}
        <div className="bg-white rounded-lg shadow-sm border border-[#E0DEDB] overflow-hidden">
          {loading ? (
            <div className="p-8 text-center">
              <div className="inline-block animate-spin rounded-full h-10 w-10 border-b-2 border-blue-600"></div>
              <p className="mt-3 text-sm text-[#605A57]">Loading benchmark data...</p>
            </div>
          ) : error ? (
            <div className="p-8 text-center">
              <p className="text-sm text-red-600 font-semibold">Error: {error}</p>
            </div>
          ) : benchmarkData.length > 0 ? (
            <div className="overflow-x-auto">
              <table className="min-w-full divide-y divide-[#E0DEDB]">
                <thead className="bg-[#F7F5F3]">
                  <tr>
                    <th className="px-6 py-3 text-left text-xs font-medium text-[#37322F] uppercase tracking-wider">Circuit</th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-[#37322F] uppercase tracking-wider">Framework</th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-[#37322F] uppercase tracking-wider">Language</th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-[#37322F] uppercase tracking-wider">Platform</th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-[#37322F] uppercase tracking-wider">Device</th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-[#37322F] uppercase tracking-wider">Proving Time (s)</th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-[#37322F] uppercase tracking-wider">Verification Time (s)</th>
                  </tr>
                </thead>
                <tbody className="bg-white divide-y divide-[#E0DEDB]">
                  {benchmarkData.map((item, index) => {
                    const isExpanded = expandedRows.has(item.id || index.toString());
                    return (
                      <React.Fragment key={item.id || index}>
                        {/* Main Row */}
                        <tr
                          className="hover:bg-[#F7F5F3] cursor-pointer transition-colors"
                          onClick={() => toggleRow(item.id || index.toString())}
                        >
                          <td className="px-6 py-4 text-sm font-semibold text-[#37322F]">{item.circuit}</td>
                          <td className="px-6 py-4">
                            <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-purple-100 text-purple-800">
                              {item.framework}
                            </span>
                          </td>
                          <td className="px-6 py-4">
                            <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-orange-100 text-orange-800">
                              {item.language}
                            </span>
                          </td>
                          <td className="px-6 py-4">
                            <span className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${item.deviceInfo?.platform === 'Android' ? 'bg-green-100 text-green-800' : 'bg-blue-100 text-blue-800'
                              }`}>
                              {item.deviceInfo?.platform || 'Unknown'}
                            </span>
                          </td>
                          <td className="px-6 py-4 text-sm text-[#605A57]">{item.deviceInfo?.device || 'N/A'}</td>
                          <td className="px-6 py-4 text-sm font-semibold text-[#37322F]">{(item.provingTimeMiliSeconds / 1000).toFixed(2)}</td>
                          <td className="px-6 py-4 text-sm font-semibold text-[#37322F]">{(item.verificationTimeMiliSeconds / 1000).toFixed(2)}</td>
                        </tr>

                        {/* Expanded Details Row */}
                        {isExpanded && (
                          <tr>
                            <td colSpan={7} className="px-6 py-4 bg-[#F7F5F3]">
                              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                                {/* Device Info */}
                                <div className="bg-white rounded-lg p-3 shadow-sm border border-[rgba(55,50,47,0.12)]">
                                  <h4 className="text-xs font-bold text-[#37322F] mb-2 flex items-center">
                                    <svg className="w-4 h-4 mr-1.5 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 18h.01M8 21h8a2 2 0 002-2V5a2 2 0 00-2-2H8a2 2 0 00-2 2v14a2 2 0 002 2z" />
                                    </svg>
                                    Device Information
                                  </h4>
                                  <div className="space-y-1.5 text-xs">
                                    <div className="flex justify-between">
                                      <span className="text-[#605A57]">Device:</span>
                                      <span className="font-medium text-[#37322F]">{item.deviceInfo?.device || 'N/A'}</span>
                                    </div>
                                    {item.deviceInfo?.manufacturer && (
                                      <div className="flex justify-between">
                                        <span className="text-[#605A57]">Manufacturer:</span>
                                        <span className="font-medium text-[#37322F]">{item.deviceInfo.manufacturer}</span>
                                      </div>
                                    )}
                                    {item.deviceInfo?.androidVersion && (
                                      <div className="flex justify-between">
                                        <span className="text-[#605A57]">Android Version:</span>
                                        <span className="font-medium text-[#37322F]">{item.deviceInfo.androidVersion}</span>
                                      </div>
                                    )}
                                    {item.deviceInfo?.androidId && (
                                      <div className="flex justify-between">
                                        <span className="text-[#605A57]">Android ID:</span>
                                        <span className="font-mono text-xs font-medium text-[#37322F] break-all">{item.deviceInfo.androidId}</span>
                                      </div>
                                    )}
                                    <div className="flex justify-between">
                                      <span className="text-[#605A57]">Proof Size:</span>
                                      <span className="font-medium text-[#37322F]">{formatBytes(item.proofSize)}</span>
                                    </div>
                                  </div>
                                </div>

                                {/* Memory Info */}
                                {item.deviceInfo?.memory && (
                                  <div className="bg-white rounded-lg p-3 shadow-sm border border-[rgba(55,50,47,0.12)]">
                                    <h4 className="text-xs font-bold text-[#37322F] mb-2 flex items-center">
                                      <svg className="w-4 h-4 mr-1.5 text-orange-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 3v2m6-2v2M9 19v2m6-2v2M5 9H3m2 6H3m18-6h-2m2 6h-2M7 19h10a2 2 0 002-2V7a2 2 0 00-2-2H7a2 2 0 00-2 2v10a2 2 0 002 2zM9 9h6v6H9V9z" />
                                      </svg>
                                      Memory Usage
                                    </h4>
                                    <div className="space-y-1.5 text-xs">
                                      <div className="flex justify-between">
                                        <span className="text-[#605A57]">Total RAM:</span>
                                        <span className="font-medium text-[#37322F]">{formatBytes(item.deviceInfo.memory.totalPhysicalMemory)}</span>
                                      </div>
                                      <div className="flex justify-between">
                                        <span className="text-[#605A57]">Peak Usage:</span>
                                        <span className="font-medium text-[#37322F]">{formatBytes(item.deviceInfo.memory.peakMemoryUsage)}</span>
                                      </div>
                                      <div className="flex justify-between">
                                        <span className="text-[#605A57]">Consumed:</span>
                                        <span className="font-medium text-[#37322F]">{formatBytes(item.deviceInfo.memory.memoryConsumedByProof)}</span>
                                      </div>
                                      <div className="flex justify-between">
                                        <span className="text-[#605A57]">Peak Load:</span>
                                        <span className="font-semibold text-[#37322F]">{item.deviceInfo.memory.peakMemoryLoadInPercentage.toFixed(1)}%</span>
                                      </div>
                                      <div className="flex justify-between">
                                        <span className="text-[#605A57]">Consumed %:</span>
                                        <span className="font-semibold text-[#37322F]">{item.deviceInfo.memory.memoryConsumedInPercentage.toFixed(1)}%</span>
                                      </div>
                                    </div>
                                  </div>
                                )}

                                {/* Battery & Timing Info */}
                                <div className="bg-white rounded-lg p-3 shadow-sm border border-[rgba(55,50,47,0.12)]">
                                  <h4 className="text-xs font-bold text-[#37322F] mb-2 flex items-center">
                                    <svg className="w-4 h-4 mr-1.5 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13 10V3L4 14h7v7l9-11h-7z" />
                                    </svg>
                                    Performance Metrics
                                  </h4>
                                  <div className="space-y-1.5 text-xs">
                                    <div className="flex justify-between">
                                      <span className="text-[#605A57]">Proving Time:</span>
                                      <span className="font-semibold text-[#37322F]">{(item.provingTimeMiliSeconds / 1000).toFixed(3)}s</span>
                                    </div>
                                    <div className="flex justify-between">
                                      <span className="text-[#605A57]">Verification Time:</span>
                                      <span className="font-semibold text-[#37322F]">{(item.verificationTimeMiliSeconds / 1000).toFixed(3)}s</span>
                                    </div>
                                    <div className="flex justify-between">
                                      <span className="text-[#605A57]">Total Time:</span>
                                      <span className="font-semibold text-[#37322F]">{((item.provingTimeMiliSeconds + item.verificationTimeMiliSeconds) / 1000).toFixed(3)}s</span>
                                    </div>
                                    {item.deviceInfo?.battery && (
                                      <>
                                        <div className="flex justify-between pt-1.5 border-t border-[rgba(55,50,47,0.12)]">
                                          <span className="text-[#605A57]">Battery Before:</span>
                                          <span className="font-medium text-[#37322F]">{item.deviceInfo.battery.batteryBeforeProof}%</span>
                                        </div>
                                        <div className="flex justify-between">
                                          <span className="text-[#605A57]">Battery After:</span>
                                          <span className="font-medium text-[#37322F]">{item.deviceInfo.battery.batteryAfterProof}%</span>
                                        </div>
                                        <div className="flex justify-between">
                                          <span className="text-[#605A57]">Consumed:</span>
                                          <span className="font-semibold text-[#37322F]">{item.deviceInfo.battery.batteryConsumed}%</span>
                                        </div>
                                      </>
                                    )}
                                  </div>
                                </div>

                                {/* Timestamp */}
                                <div className="bg-white rounded-lg p-3 shadow-sm md:col-span-2 lg:col-span-3">
                                  <div className="flex items-center justify-between text-xs">
                                    <div className="flex items-center text-[#605A57]">
                                      <svg className="w-4 h-4 mr-1.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                                      </svg>
                                      <span>Benchmark recorded on: <span className="font-medium text-[#37322F]">{formatTimestamp(item.timestamp)}</span></span>
                                    </div>
                                  </div>
                                </div>
                              </div>
                            </td>
                          </tr>
                        )}
                      </React.Fragment>
                    );
                  })}
                </tbody>
              </table>
            </div>
          ) : (
            <div className="p-8 text-center">
              <p className="text-sm text-[#605A57]">No benchmark data matches the selected filters</p>
            </div>
          )
          }
        </div>

        {/* Pagination Controls */}
        {!loading && !error && totalCount > 0 && (
          <div className="mt-4 bg-white rounded-lg shadow-sm p-4 border border-[#E0DEDB]">
            <div className="flex flex-col sm:flex-row items-center justify-between gap-3">
              {/* Items per page selector */}
              <div className="flex items-center gap-2">
                <span className="text-xs font-medium text-[#37322F]">Show</span>
                <select
                  value={itemsPerPage}
                  onChange={(e) => handleItemsPerPageChange(Number(e.target.value))}
                  className="px-2 py-1.5 border border-[#E0DEDB] rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent text-xs bg-white"
                >
                  <option value={10}>10</option>
                  <option value={20}>20</option>
                  <option value={30}>30</option>
                  <option value={40}>40</option>
                  <option value={50}>50</option>
                </select>
                <span className="text-xs font-medium text-[#37322F]">per page</span>
              </div>

              {/* Page info */}
              <div className="text-xs text-[#605A57]">
                Showing <span className="font-bold text-[#37322F]">{(currentPage - 1) * itemsPerPage + 1}</span> to{' '}
                <span className="font-bold text-[#37322F]">{Math.min(currentPage * itemsPerPage, totalCount)}</span> of{' '}
                <span className="font-bold text-[#37322F]">{totalCount}</span> results
              </div>

              {/* Page numbers */}
              <div className="flex items-center gap-1">
                {/* Previous button */}
                <button
                  onClick={() => setCurrentPage(prev => Math.max(1, prev - 1))}
                  disabled={currentPage === 1}
                  className={`px-3 py-1.5 rounded-lg text-xs font-medium transition-colors ${currentPage === 1
                    ? 'bg-gray-100 text-gray-400 cursor-not-allowed'
                    : 'bg-white text-[#37322F] hover:bg-blue-600 hover:text-white border border-[#E0DEDB]'
                    }`}
                >
                  Previous
                </button>

                {/* Page numbers */}
                {getPageNumbers().map((page, index) => (
                  <button
                    key={index}
                    onClick={() => typeof page === 'number' && setCurrentPage(page)}
                    disabled={page === '...'}
                    className={`px-2.5 py-1.5 rounded-lg text-xs font-medium transition-colors ${page === currentPage
                      ? 'bg-blue-600 text-white'
                      : page === '...'
                        ? 'bg-white text-gray-400 cursor-default'
                        : 'bg-white text-[#37322F] hover:bg-blue-600 hover:text-white border border-[#E0DEDB]'
                      }`}
                  >
                    {page}
                  </button>
                ))}

                {/* Next button */}
                <button
                  onClick={() => setCurrentPage(prev => Math.min(totalPages, prev + 1))}
                  disabled={currentPage === totalPages}
                  className={`px-3 py-1.5 rounded-lg text-xs font-medium transition-colors ${currentPage === totalPages
                    ? 'bg-gray-100 text-gray-400 cursor-not-allowed'
                    : 'bg-white text-[#37322F] hover:bg-blue-600 hover:text-white border border-[#E0DEDB]'
                    }`}
                >
                  Next
                </button>
              </div>
            </div>
          </div>
        )}

        {/* Summary Stats */}
        {!loading && !error && benchmarkData.length > 0 && (
          <div className="my-6 grid grid-cols-1 md:grid-cols-4 gap-4">
            <div className="bg-white rounded-lg p-5 shadow-sm border border-[#E0DEDB]">
              <div className="flex items-start justify-between">
                <div>
                  <p className="text-xs font-medium text-[#605A57] uppercase tracking-wider mb-2">Total Benchmarks</p>
                  <p className="text-2xl font-bold text-[#37322F]">{totalCount}</p>
                </div>
                <div className="p-2 rounded-lg bg-[#F7F5F3]">
                  <svg className="w-5 h-5 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                  </svg>
                </div>
              </div>
            </div>
            <div className="bg-white rounded-lg p-5 shadow-sm border border-[#E0DEDB]">
              <div className="flex items-start justify-between">
                <div>
                  <p className="text-xs font-medium text-[#605A57] uppercase tracking-wider mb-2">Avg Proving Time</p>
                  <p className="text-2xl font-bold text-[#37322F]">
                    {(benchmarkData.reduce((sum, item) => sum + item.provingTimeMiliSeconds, 0) / benchmarkData.length / 1000).toFixed(2)}s
                  </p>
                </div>
                <div className="p-2 rounded-lg bg-[#F7F5F3]">
                  <svg className="w-5 h-5 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                </div>
              </div>
            </div>
            <div className="bg-white rounded-lg p-5 shadow-sm border border-[#E0DEDB]">
              <div className="flex items-start justify-between">
                <div>
                  <p className="text-xs font-medium text-[#605A57] uppercase tracking-wider mb-2">Avg Verification</p>
                  <p className="text-2xl font-bold text-[#37322F]">
                    {(benchmarkData.reduce((sum, item) => sum + item.verificationTimeMiliSeconds, 0) / benchmarkData.length / 1000).toFixed(2)}s
                  </p>
                </div>
                <div className="p-2 rounded-lg bg-[#F7F5F3]">
                  <svg className="w-5 h-5 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                </div>
              </div>
            </div>
            <div className="bg-white rounded-lg p-5 shadow-sm border border-[#E0DEDB]">
              <div className="flex items-start justify-between">
                <div>
                  <p className="text-xs font-medium text-[#605A57] uppercase tracking-wider mb-2">Avg Memory Used</p>
                  <p className="text-2xl font-bold text-[#37322F]">
                    {(benchmarkData.reduce((sum, item) => sum + (item.deviceInfo?.memory?.memoryConsumedInPercentage || 0), 0) / benchmarkData.length).toFixed(1)}%
                  </p>
                </div>
                <div className="p-2 rounded-lg bg-[#F7F5F3]">
                  <svg className="w-5 h-5 text-orange-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 3v2m6-2v2M9 19v2m6-2v2M5 9H3m2 6H3m18-6h-2m2 6h-2M7 19h10a2 2 0 002-2V7a2 2 0 00-2-2H7a2 2 0 00-2 2v10a2 2 0 002 2zM9 9h6v6H9V9z" />
                  </svg>
                </div>
              </div>
            </div>
          </div>
        )}

      </section>
    </div>
  );
}
