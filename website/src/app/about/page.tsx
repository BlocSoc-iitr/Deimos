'use client';

export default function About() {
  return (
    <div className="max-w-4xl mx-auto px-4 py-12">
      <h1 className="text-4xl font-bold mb-8">About Deimos</h1>
      
      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Project Overview</h2>
        <p className="mb-4">
          Deimos is an open-source benchmarking suite for evaluating zero-knowledge virtual machines (zkVMs) 
          on mobile devices. The project provides consistent, repeatable performance tests across various zkVM 
          tools to help developers understand and optimize ZK proof generation on mobile platforms.
        </p>
        <p className="mb-4">
          The name "Deimos" comes from one of Mars' moons, symbolizing the project's mission to explore and 
          measure the performance landscape of mobile zero-knowledge proving.
        </p>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Project Goals</h2>
        <ul className="list-disc ml-6 mb-4">
          <li>Benchmark zkVM performance for mobile-specific environments</li>
          <li>Compare multiple zkVM frameworks (MoPro, imp1, ProveKit, RISC Zero, SP1)</li>
          <li>Measure performance of common cryptographic functions (SHA-256, Keccak-256, Poseidon, etc.)</li>
          <li>Provide a centralized dashboard for viewing and comparing results</li>
          <li>Create a neutral, comprehensive benchmark suite for the ZK community</li>
          <li>Help developers make informed decisions about ZK implementations</li>
        </ul>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Why Mobile ZK Benchmarking?</h2>
        <p className="mb-4">
          Zero-knowledge proofs are increasingly being used in mobile applications for privacy-preserving 
          authentication, blockchain interactions, and secure computation. However, mobile devices have 
          unique constraints:
        </p>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>Limited Memory:</strong> Mobile devices have less RAM than desktop computers</li>
          <li><strong>Battery Constraints:</strong> Proof generation consumes significant power</li>
          <li><strong>Thermal Throttling:</strong> Sustained computation can cause performance degradation</li>
          <li><strong>Varied Hardware:</strong> Wide range of device capabilities across the market</li>
          <li><strong>OS Limitations:</strong> Different memory management and process restrictions</li>
        </ul>
        <p className="mb-4">
          Deimos addresses these challenges by providing real-world performance data from actual mobile devices, 
          helping developers understand what's feasible and optimize their implementations accordingly.
        </p>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Current Status</h2>
        <p className="mb-4">
          Deimos is under active development. The project currently focuses on:
        </p>
        <ul className="list-disc ml-6 mb-4">
          <li>MoPro framework integration</li>
          <li>Circom circuit implementations for various hash functions</li>
          <li>Android mobile applications for benchmarking</li>
          <li>CI/CD pipeline for automated circuit validation</li>
          <li>Documentation and developer guides</li>
        </ul>
        <p className="mb-4">
          <strong>Development Branch:</strong> Active development happens on the <code>dev</code> branch with 
          frequent updates and breaking changes.
        </p>
        <p className="mb-4">
          <strong>Stable Branch:</strong> The <code>main</code> branch contains stable releases only.
        </p>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Technology Stack</h2>
        
        <h3 className="text-xl font-bold mb-2">Circuits</h3>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>Circom:</strong> Primary circuit language for hash function implementations</li>
          <li><strong>Noir:</strong> Planned support for alternative circuit implementations</li>
          <li><strong>snarkjs:</strong> Proof generation and verification</li>
          <li><strong>Groth16:</strong> Proving system used for benchmarks</li>
        </ul>

        <h3 className="text-xl font-bold mb-2">Mobile Integration</h3>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>MoPro:</strong> Mobile proving framework</li>
          <li><strong>Rust:</strong> Core logic and FFI bindings</li>
          <li><strong>UniFFI:</strong> Cross-language FFI generation</li>
          <li><strong>Kotlin:</strong> Android application development</li>
          <li><strong>Swift:</strong> iOS application development (planned)</li>
        </ul>

        <h3 className="text-xl font-bold mb-2">Website</h3>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>Next.js:</strong> React framework for the dashboard</li>
          <li><strong>TypeScript:</strong> Type-safe JavaScript</li>
          <li><strong>Tailwind CSS:</strong> Utility-first CSS framework</li>
        </ul>

        <h3 className="text-xl font-bold mb-2">CI/CD</h3>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>GitHub Actions:</strong> Automated testing and validation</li>
          <li><strong>Circuit Validation:</strong> Automatic compilation and verification</li>
        </ul>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Supported Primitives</h2>
        
        <h3 className="text-xl font-bold mb-2">Hash Functions</h3>
        <ul className="list-disc ml-6 mb-4">
          <li>SHA-256 (implemented)</li>
          <li>Keccak-256 (implemented)</li>
          <li>BLAKE2s-256 (implemented)</li>
          <li>Poseidon (implemented)</li>
          <li>MiMC-256 (implemented)</li>
          <li>Pedersen (implemented)</li>
        </ul>

        <h3 className="text-xl font-bold mb-2">Planned Primitives</h3>
        <ul className="list-disc ml-6 mb-4">
          <li>EdDSA signature verification</li>
          <li>ECDSA signature verification</li>
          <li>JWT parsing and validation</li>
          <li>Merkle tree operations</li>
        </ul>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Community and Support</h2>
        <p className="mb-4">
          Deimos is developed by BlocSoc-iitr and the open-source community. We welcome contributions from 
          developers, researchers, and anyone interested in mobile zero-knowledge proving.
        </p>
        
        <h3 className="text-xl font-bold mb-2">Get Involved</h3>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>GitHub:</strong> https://github.com/BlocSoc-iitr/Deimos</li>
          <li><strong>Issues:</strong> Report bugs or request features</li>
          <li><strong>Pull Requests:</strong> Contribute code or documentation</li>
          <li><strong>Discussions:</strong> Ask questions and share ideas</li>
        </ul>

        <h3 className="text-xl font-bold mb-2">MoPro Community</h3>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>Website:</strong> https://zkmopro.org</li>
          <li><strong>Twitter:</strong> @zkmopro</li>
          <li><strong>Telegram:</strong> @zkmopro</li>
        </ul>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Roadmap</h2>
        
        <h3 className="text-xl font-bold mb-2">Current Phase (Q4 2024 - Q1 2025)</h3>
        <ul className="list-disc ml-6 mb-4">
          <li>Complete MoPro integration for core hash functions</li>
          <li>Implement Android benchmarking apps</li>
          <li>Set up automated circuit validation</li>
          <li>Create comprehensive documentation</li>
        </ul>

        <h3 className="text-xl font-bold mb-2">Next Phase (Q2 2025)</h3>
        <ul className="list-disc ml-6 mb-4">
          <li>Database integration for storing benchmark results</li>
          <li>Interactive web dashboard with visualizations</li>
          <li>iOS application implementations</li>
          <li>Add signature verification circuits</li>
        </ul>

        <h3 className="text-xl font-bold mb-2">Future Plans</h3>
        <ul className="list-disc ml-6 mb-4">
          <li>Integration with imp1 and ProveKit</li>
          <li>Support for RISC Zero and SP1</li>
          <li>Battery usage measurement</li>
          <li>Cross-device comparison tools</li>
          <li>Public benchmark result repository</li>
        </ul>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Research Applications</h2>
        <p className="mb-4">
          Deimos serves as a research tool for understanding mobile ZK performance. Potential research areas:
        </p>
        <ul className="list-disc ml-6 mb-4">
          <li>Comparing ZK-friendly vs traditional hash functions on mobile</li>
          <li>Analyzing memory usage patterns across different circuits</li>
          <li>Measuring battery impact of proof generation</li>
          <li>Evaluating thermal throttling effects on performance</li>
          <li>Cross-platform performance analysis (iOS vs Android)</li>
          <li>Device capability profiling for ZK applications</li>
        </ul>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Use Cases</h2>
        
        <h3 className="text-xl font-bold mb-2">For Developers</h3>
        <ul className="list-disc ml-6 mb-4">
          <li>Evaluate feasibility of ZK features on mobile</li>
          <li>Choose appropriate hash functions for mobile apps</li>
          <li>Optimize circuit implementations</li>
          <li>Set realistic performance expectations</li>
        </ul>

        <h3 className="text-xl font-bold mb-2">For Researchers</h3>
        <ul className="list-disc ml-6 mb-4">
          <li>Study mobile ZK performance characteristics</li>
          <li>Compare different proving systems</li>
          <li>Analyze resource consumption patterns</li>
          <li>Publish benchmark results</li>
        </ul>

        <h3 className="text-xl font-bold mb-2">For Product Teams</h3>
        <ul className="list-disc ml-6 mb-4">
          <li>Make informed technology decisions</li>
          <li>Understand user experience implications</li>
          <li>Plan feature rollouts based on device capabilities</li>
          <li>Set minimum device requirements</li>
        </ul>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Acknowledgments</h2>
        <p className="mb-4">
          Deimos builds upon the work of many open-source projects and communities:
        </p>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>MoPro:</strong> Mobile proving framework</li>
          <li><strong>Circom:</strong> Circuit language and compiler</li>
          <li><strong>snarkjs:</strong> JavaScript implementation of zkSNARK schemes</li>
          <li><strong>circomlib:</strong> Circuit library</li>
          <li><strong>hash-circuits:</strong> Hash function implementations by Faulhorn Labs</li>
          <li><strong>UniFFI:</strong> Cross-language FFI by Mozilla</li>
        </ul>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">License</h2>
        <p className="mb-4">
          Deimos is licensed under the MIT License. You are free to use, modify, and distribute the code 
          for any purpose, including commercial applications.
        </p>
        <p className="mb-4">
          See the LICENSE file in the repository for full details.
        </p>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Contact</h2>
        <p className="mb-4">
          For questions, suggestions, or collaboration opportunities:
        </p>
        <ul className="list-disc ml-6 mb-4">
          <li>Open an issue on GitHub</li>
          <li>Start a discussion in the repository</li>
          <li>Reach out through the MoPro community channels</li>
        </ul>
      </section>
    </div>
  );
}
