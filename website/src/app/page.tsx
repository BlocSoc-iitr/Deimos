'use client';
import { useState } from 'react';
import { benchmarkData } from './table';

export default function Home() {
  const [filterCircuit, setFilterCircuit] = useState<string>('all');
  const [filterFramework, setFilterFramework] = useState<string>('all');
  const [filterLanguage, setFilterLanguage] = useState<string>('all');
  const [filterPlatform, setFilterPlatform] = useState<string>('all');

  // Get unique values for filters
  const circuits = ['all', ...Array.from(new Set(benchmarkData.map(d => d.circuit)))];
  const frameworks = ['all', ...Array.from(new Set(benchmarkData.map(d => d.framework)))];
  const languages = ['all', ...Array.from(new Set(benchmarkData.map(d => d.language)))];
  const platforms = ['all', ...Array.from(new Set(benchmarkData.map(d => d.platform)))];

  // Filter data
  const filteredData = benchmarkData.filter(item => {
    return (
      (filterCircuit === 'all' || item.circuit === filterCircuit) &&
      (filterFramework === 'all' || item.framework === filterFramework) &&
      (filterLanguage === 'all' || item.language === filterLanguage) &&
      (filterPlatform === 'all' || item.platform === filterPlatform)
    );
  });

  return (
    <div className="min-h-screen">
      {/* Hero Section */}
      <section className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">


        {/* Filters */}
        <div className="mb-8 flex flex-wrap gap-4 justify-center">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Circuit</label>
            <select
              value={filterCircuit}
              onChange={(e) => setFilterCircuit(e.target.value)}
              className="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            >
              {circuits.map(circuit => (
                <option key={circuit} value={circuit}>
                  {circuit === 'all' ? 'All Circuits' : circuit}
                </option>
              ))}
            </select>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Framework</label>
            <select
              value={filterFramework}
              onChange={(e) => setFilterFramework(e.target.value)}
              className="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            >
              {frameworks.map(framework => (
                <option key={framework} value={framework}>
                  {framework === 'all' ? 'All Frameworks' : framework}
                </option>
              ))}
            </select>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Language</label>
            <select
              value={filterLanguage}
              onChange={(e) => setFilterLanguage(e.target.value)}
              className="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            >
              {languages.map(language => (
                <option key={language} value={language}>
                  {language === 'all' ? 'All Languages' : language}
                </option>
              ))}
            </select>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Platform</label>
            <select
              value={filterPlatform}
              onChange={(e) => setFilterPlatform(e.target.value)}
              className="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            >
              {platforms.map(platform => (
                <option key={platform} value={platform}>
                  {platform === 'all' ? 'All Platforms' : platform}
                </option>
              ))}
            </select>
          </div>
        </div>

        {/* Benchmark Table */}
        <div className="bg-white rounded-lg shadow-lg overflow-hidden">
          <div className="overflow-x-auto">
            <table className="min-w-full divide-y divide-gray-200">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Circuit
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Framework
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Language
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Platform
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Device
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Proving Time (s)
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Verification Time (s)
                  </th>
                </tr>
              </thead>
              <tbody className="bg-white divide-y divide-gray-200">
                {filteredData.length > 0 ? (
                  filteredData.map((item, index) => (
                    <tr key={index} className="hover:bg-gray-50 transition-colors">
                      <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                        {item.circuit}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">
                        <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-purple-100 text-purple-800">
                          {item.framework}
                        </span>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">
                        <span className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${
                          item.language === 'Circom' ? 'bg-orange-100 text-orange-800' : 'bg-indigo-100 text-indigo-800'
                        }`}>
                          {item.language}
                        </span>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">
                        <span className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${
                          item.platform === 'Android' ? 'bg-green-100 text-green-800' : 'bg-blue-100 text-blue-800'
                        }`}>
                          {item.platform}
                        </span>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">
                        {item.device}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900 font-semibold">
                        {item.provingTime.toFixed(2)}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900 font-semibold">
                        {item.verificationTime.toFixed(2)}
                      </td>
                    </tr>
                  ))
                ) : (
                  <tr>
                    <td colSpan={7} className="px-6 py-8 text-center text-sm text-gray-500">
                      No benchmark data matches the selected filters
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        </div>

        {/* Summary Stats */}
        {filteredData.length > 0 && (
          <div className="mt-8 grid grid-cols-1 md:grid-cols-3 gap-6">
            <div className="bg-blue-50 rounded-lg p-6">
              <h3 className="text-sm font-medium text-blue-900 mb-2">Total Benchmarks</h3>
              <p className="text-3xl font-bold text-blue-600">{filteredData.length}</p>
            </div>
            <div className="bg-green-50 rounded-lg p-6">
              <h3 className="text-sm font-medium text-green-900 mb-2">Avg Proving Time</h3>
              <p className="text-3xl font-bold text-green-600">
                {(filteredData.reduce((sum, item) => sum + item.provingTime, 0) / filteredData.length).toFixed(2)}s
              </p>
            </div>
            <div className="bg-purple-50 rounded-lg p-6">
              <h3 className="text-sm font-medium text-purple-900 mb-2">Avg Verification Time</h3>
              <p className="text-3xl font-bold text-purple-600">
                {(filteredData.reduce((sum, item) => sum + item.verificationTime, 0) / filteredData.length).toFixed(2)}s
              </p>
            </div>
          </div>
        )}

{/* Hero Section */}
<div className="text-center mt-12">
          <h1 className="text-4xl md:text-5xl font-bold text-gray-900 mb-4">
            <span className="text-blue-600">DEIMOS</span>
          </h1>
          <p className="text-lg text-gray-600 max-w-3xl mx-auto">
            Compare zero-knowledge proof performance across different circuits, languages, frameworks, and mobile platforms
          </p>
        </div>


      </section>
    </div>
  );
}
