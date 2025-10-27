'use client';
import Link from 'next/link';

export default function Home() {
  return (
    <div className="min-h-screen flex flex-col">

      {/* Footer */}
      <footer className="bg-gray-800 text-white py-8">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center">
            <p>© {new Date().getFullYear()} Deimos. All rights reserved.</p>
            <p className="text-sm text-gray-400 mt-2">An open-source project for zkVM benchmarking</p>
          </div>
        </div>
      </footer>
    </div>
  );
}
