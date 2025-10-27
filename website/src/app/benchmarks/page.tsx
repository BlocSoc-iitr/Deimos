'use client';

export default function Benchmarks() {
  return (
    <div className="max-w-4xl mx-auto px-4 py-12">
      <h1 className="text-4xl font-bold mb-8">Benchmarks</h1>
      
      <section className="mb-12">
        <div className="bg-blue-50 border border-blue-200 rounded p-6">
          <h2 className="text-xl font-bold mb-2">Coming Soon</h2>
          <p className="mb-4">
            The benchmark dashboard is currently under development. This page will display:
          </p>
          <ul className="list-disc ml-6 mb-4">
            <li>Performance metrics from mobile devices</li>
            <li>Comparison charts across different circuits</li>
            <li>Device-specific benchmark results</li>
            <li>Framework comparison data</li>
            <li>Historical performance trends</li>
          </ul>
        </div>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">What Will Be Benchmarked</h2>
        
        <h3 className="text-xl font-bold mb-2">Hash Functions</h3>
        <ul className="list-disc ml-6 mb-4">
          <li>SHA-256</li>
          <li>Keccak-256</li>
          <li>BLAKE2s-256</li>
          <li>Poseidon</li>
          <li>MiMC-256</li>
          <li>Pedersen</li>
        </ul>

        <h3 className="text-xl font-bold mb-2">Metrics</h3>
        <ul className="list-disc ml-6 mb-4">
          <li>Proving time (milliseconds)</li>
          <li>Verification time (milliseconds)</li>
          <li>Memory usage (MB)</li>
          <li>Proof size (bytes)</li>
          <li>Success rate (percentage)</li>
          <li>Battery impact (planned)</li>
        </ul>

        <h3 className="text-xl font-bold mb-2">Platforms</h3>
        <ul className="list-disc ml-6 mb-4">
          <li>Android devices (various models)</li>
          <li>iOS devices (planned)</li>
        </ul>

        <h3 className="text-xl font-bold mb-2">Frameworks</h3>
        <ul className="list-disc ml-6 mb-4">
          <li>MoPro (current)</li>
          <li>imp1 (planned)</li>
          <li>ProveKit (planned)</li>
          <li>RISC Zero (planned)</li>
          <li>SP1 (planned)</li>
        </ul>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Current Development Status</h2>
        <p className="mb-4">
          The project is currently focused on:
        </p>
        <ul className="list-disc ml-6 mb-4">
          <li>Implementing mobile benchmarking apps</li>
          <li>Collecting initial performance data</li>
          <li>Setting up database infrastructure</li>
          <li>Designing visualization components</li>
        </ul>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Run Your Own Benchmarks</h2>
        <p className="mb-4">
          You can run benchmarks on your own devices right now:
        </p>
        <ol className="list-decimal ml-6 mb-4">
          <li className="mb-2">Clone the repository</li>
          <li className="mb-2">Navigate to benchmarking-suite/moPro/mopro-sha256 (or other apps)</li>
          <li className="mb-2">Follow the setup instructions in the README</li>
          <li className="mb-2">Build and run on your device</li>
          <li className="mb-2">View results in the app</li>
        </ol>
        <p className="mb-4">
          See the Getting Started guide for detailed instructions.
        </p>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Contribute Benchmark Data</h2>
        <p className="mb-4">
          Once the database is set up, you will be able to contribute your benchmark results to help 
          build a comprehensive performance database for the community.
        </p>
      </section>
    </div>
  );
}
