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
      
      </section>

    </div>
  );
}
