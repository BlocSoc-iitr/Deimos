'use client';
import Link from 'next/link';

export default function Home() {
  return (
    <div className="min-h-screen">
      {/* Hero Section */}
      <section className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20 text-center">
        <h1 className="text-5xl md:text-6xl font-bold text-gray-900 mb-6">
          zkVM Mobile
          <br />
          <span className="text-blue-600">Benchmarking Suite</span>
        </h1>
        <p className="text-xl text-gray-600 mb-12 max-w-3xl mx-auto leading-relaxed">
          An open-source benchmarking suite for evaluating zero-knowledge virtual machines (zkVMs) 
          on mobile devices. Compare performance, analyze metrics, and optimize your zkVM implementations 
          across different mobile platforms.
        </p>
        
        {/* CTA Buttons */}
        <div className="flex flex-col sm:flex-row gap-4 justify-center mb-20">
          <Link 
            href="/get-started" 
            className="bg-blue-600 text-white px-8 py-4 rounded-lg font-semibold hover:bg-blue-700 transition-colors"
          >
            Get Started
          </Link>
          <Link 
            href="/documentation" 
            className="border border-gray-300 text-gray-700 px-8 py-4 rounded-lg font-semibold hover:bg-gray-50 transition-colors"
          >
            View Documentation
          </Link>
        </div>
      </section>

      {/* Features Section */}
      <section className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20">
        <div className="grid md:grid-cols-3 gap-12">
          {/* Cross-Platform Compatibility */}
          <div className="text-center">
            <div className="w-16 h-16 bg-blue-100 rounded-lg flex items-center justify-center mx-auto mb-6">
              <svg className="w-8 h-8 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 18h.01M8 21h8a2 2 0 002-2V5a2 2 0 00-2-2H8a2 2 0 00-2 2v14a2 2 0 002 2z" />
              </svg>
            </div>
            <h3 className="text-xl font-semibold text-gray-900 mb-4">Cross-Platform Compatibility</h3>
            <p className="text-gray-600 leading-relaxed">
              Test and benchmark zkVMs across iOS and Android devices with consistent, 
              reliable performance measurements.
            </p>
          </div>

          {/* Comprehensive Metrics */}
          <div className="text-center">
            <div className="w-16 h-16 bg-blue-100 rounded-lg flex items-center justify-center mx-auto mb-6">
              <svg className="w-8 h-8 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
              </svg>
            </div>
            <h3 className="text-xl font-semibold text-gray-900 mb-4">Comprehensive Metrics</h3>
            <p className="text-gray-600 leading-relaxed">
              Detailed performance analytics including execution time, memory usage, 
              battery consumption, and proof generation efficiency.
            </p>
          </div>

          {/* Open Source & Extensible */}
          <div className="text-center">
            <div className="w-16 h-16 bg-blue-100 rounded-lg flex items-center justify-center mx-auto mb-6">
              <svg className="w-8 h-8 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10 20l4-16m4 4l4 4-4 4M6 16l-4-4 4-4" />
              </svg>
            </div>
            <h3 className="text-xl font-semibold text-gray-900 mb-4">Open Source & Extensible</h3>
            <p className="text-gray-600 leading-relaxed">
              Built with modularity in mind. Add custom benchmarks, integrate new zkVMs, 
              and contribute to the growing ecosystem.
            </p>
          </div>
        </div>
      </section>

      {/* Additional Info Section */}
      <section className="bg-gray-50 py-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h2 className="text-3xl font-bold text-gray-900 mb-6">
            Ready to benchmark your zkVM?
          </h2>
          <p className="text-lg text-gray-600 mb-8 max-w-2xl mx-auto">
            Join the community of developers optimizing zero-knowledge applications for mobile devices.
          </p>
          <Link 
            href="/get-started" 
            className="bg-blue-600 text-white px-8 py-4 rounded-lg font-semibold hover:bg-blue-700 transition-colors inline-block"
          >
            Start Benchmarking
          </Link>
        </div>
      </section>
    </div>
  );
}
