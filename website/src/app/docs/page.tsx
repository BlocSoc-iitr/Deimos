'use client';

export default function Documentation() {
  return (
    <div className="max-w-4xl mx-auto px-4 py-12">
      <h1 className="text-4xl font-bold mb-8">Documentation</h1>
      
      <section id="what-is-deimos" className="mb-12">
        <h2 className="text-2xl font-bold mb-4">What is Deimos?</h2>
        <p className="mb-4">
          Deimos is an open-source project, designed to provide comprehensive benchmark data that allows developers to compare the performance of different zkVMs across various devices. This enables developers to choose the most suitable zkVM based on their target device requirements.
        </p>
        <p className="mb-4">
          Deimos serves two primary functions:
        </p>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>Benchmarking Suite:</strong> A comprehensive toolkit for evaluating zero-knowledge virtual machines (zkVMs) on mobile devices</li>
          <li><strong>Public Dashboard:</strong> A web-based service where users can view and compare all benchmark results</li>
        </ul>
        <p className="mb-4">
          The project aims to benchmark zkVM performance for mobile-specific environments, compare multiple frameworks  
          (initially MoPro, imp1, and ProveKit), measure performance of common cryptographic & proof-related 
          hash functions  across different langauges (Circom, Noir, Halo2) 
          and make this information accessible to users via a public dashboard.
        </p>
      </section>

      <section id="technology-stack" className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Technology Stack</h2>
        <h3 className="text-xl font-bold mb-2">Circuit Development</h3>

        <div className="ml-4">
        <p className="mb-4"><strong>Circom Ecosystem:</strong></p>


        <ul className="list-disc ml-6 mb-4">
          <li><strong>Circom Compiler:</strong> Version 2.1.6 for circuit compilation</li>
          <li><strong>snarkjs:</strong> Groth16 proof generation and verification</li>
          </ul>
          
        <p className="mb-4"><strong>Circom Libraries:</strong></p>
          <ul className="list-disc ml-6 mb-4">
          <li><strong>circomlib:</strong> Standard library of circuits</li>
          <li><strong>hash-circuits:</strong> Library for Blake2s circuit</li>
          <li><strong>keccak256-circom:</strong> Library for Keccak256 circuit</li>
        </ul>
        
        <p className="mb-4"><strong>Noir Ecosystem:</strong></p>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>Noir:</strong> Version 1.0.0-beta.8</li>
          <li><strong>Nargo:</strong> Build and compilation toolchain</li>
        </ul>
        </div>

        <h3 className="text-xl font-bold mb-2">Mobile Application</h3>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>Framework:</strong> Flutter</li>
          <li><strong>Language:</strong> Dart</li>
          <li><strong>Support:</strong> Android & iOS</li>
        </ul>

        <h3 className="text-xl font-bold mb-2">Website Dashboard</h3>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>Framework:</strong> Next.js 15.5.3 with Turbopack</li>
          <li><strong>Language:</strong> TypeScript</li>
          <li><strong>Styling:</strong> Tailwind CSS</li>
        </ul>
      
      </section>

      <section id="repository-structure" className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Repository Structure</h2>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`deimos/
├── website/                    # Dashboard for displaying benchmark results
│   ├── src/app/               # Next.js application
│   └── package.json
│
├── benchmarking-suite/        # Core benchmarking implementation
│   ├── frameworks/
│   │   ├── circom/           # Circom circuit implementations
│   │   │   ├── circuits/     # Hash function circuits
│   │   │   │   ├── sha256/
│   │   │   │   ├── keccak256/
│   │   │   │   ├── blake2s256/
│   │   │   │   ├── poseidon/
│   │   │   │   ├── mimc256/
│   │   │   │   └── pedersen/
│   │   │   └── inputs/       # Test vectors
│   │   └── noir/             # Noir implementations (planned)
│   │
│   └── moPro/                # MoPro mobile integration
│       ├── mopro-sha256/     # SHA256 mobile app
│       ├── mopro-keccack256/ # Keccak256 mobile app
│       └── mopro-example-app/
│
├── .github/workflows/         # CI/CD automation
│   └── validate-circuits.yml # Circuit validation
│
├── README.md
├── CONTRIBUTING.md
├── APP_INTEGRATION_GUIDE.md
└── LICENSE`}
          </pre>
        </div>
      </section>

      <section id="quick-links" className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Quick Links</h2>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <a
            href="/docs/getstarted"
            className="block p-6 bg-blue-50 rounded-lg hover:bg-blue-100 transition-colors"
          >
            <h3 className="text-xl font-bold text-blue-900 mb-2">Getting Started</h3>
            <p className="text-blue-700">Learn how to set up and run Deimos</p>
          </a>
          <a
            href="/docs/circuits"
            className="block p-6 bg-green-50 rounded-lg hover:bg-green-100 transition-colors"
          >
            <h3 className="text-xl font-bold text-green-900 mb-2">Circuits</h3>
            <p className="text-green-700">Explore circuit implementations</p>
          </a>
          <a
            href="/docs/mopro"
            className="block p-6 bg-purple-50 rounded-lg hover:bg-purple-100 transition-colors"
          >
            <h3 className="text-xl font-bold text-purple-900 mb-2">MoPro</h3>
            <p className="text-purple-700">Mobile proving integration guide</p>
          </a>
          <a
            href="/docs/contributing"
            className="block p-6 bg-orange-50 rounded-lg hover:bg-orange-100 transition-colors"
          >
            <h3 className="text-xl font-bold text-orange-900 mb-2">Contributing</h3>
            <p className="text-orange-700">Help improve Deimos</p>
          </a>
        </div>
      </section>
    </div>
  );
}
