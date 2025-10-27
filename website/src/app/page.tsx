'use client';

export default function Home() {
  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <header className="bg-white shadow">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
          <div className="flex justify-between items-center">
            <div className="flex items-center space-x-2">
              <div className="w-10 h-10 bg-blue-600 rounded-lg flex items-center justify-center text-white font-bold">ZK</div>
              <h1 className="text-xl font-semibold text-gray-900">ZK Proof System</h1>
            </div>
            <nav className="hidden md:flex space-x-8">
              <a href="#" className="text-gray-900 font-medium">Home</a>
              <a href="#" className="text-gray-500 hover:text-gray-900">Documentation</a>
              <a href="#" className="text-gray-500 hover:text-gray-900">Examples</a>
              <a href="#" className="text-gray-500 hover:text-gray-900">About</a>
            </nav>
            <button className="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-md text-sm font-medium">
              Connect Wallet
            </button>
          </div>
        </div>
      </header>

      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div className="text-center mb-12">
          <h1 className="text-4xl font-bold text-gray-900 mb-4">Zero-Knowledge Proof Generator</h1>
          <p className="text-xl text-gray-600 max-w-3xl mx-auto">
            Generate and verify zero-knowledge proofs for your blockchain applications
          </p>
        </div>

        <div className="grid md:grid-cols-2 gap-8">
          {/* Left Column - Input */}
          <div className="bg-white p-6 rounded-xl shadow-md">
            <h2 className="text-lg font-semibold text-gray-900 mb-4">Input Data</h2>
            
            <div className="mb-6">
              <label className="block text-sm font-medium text-gray-700 mb-2">Circuit</label>
              <div className="mt-1 flex justify-center px-6 pt-5 pb-6 border-2 border-gray-300 border-dashed rounded-md">
                <div className="space-y-1 text-center">
                  <svg
                    className="mx-auto h-12 w-12 text-gray-400"
                    stroke="currentColor"
                    fill="none"
                    viewBox="0 0 48 48"
                    aria-hidden="true"
                  >
                    <path
                      d="M28 8H12a4 4 0 00-4 4v20m32-12v8m0 0v8a4 4 0 01-4 4H12a4 4 0 01-4-4v-4m32-4l-3.172-3.172a4 4 0 00-5.656 0L28 28M8 32l9.172-9.172a4 4 0 015.656 0L28 28m0 0l4 4m4-24h8m-4-4v8m-12 4h.02"
                      strokeWidth={2}
                      strokeLinecap="round"
                      strokeLinejoin="round"
                    />
                  </svg>
                  <div className="flex text-sm text-gray-600">
                    <label
                      htmlFor="file-upload"
                      className="relative cursor-pointer bg-white rounded-md font-medium text-blue-600 hover:text-blue-500 focus-within:outline-none"
                    >
                      <span>Upload a file</span>
                      <input id="file-upload" name="file-upload" type="file" className="sr-only" />
                    </label>
                    <p className="pl-1">or drag and drop</p>
                  </div>
                  <p className="text-xs text-gray-500">.wasm, .zkey, or .json up to 10MB</p>
                </div>
              </div>
            </div>

            <div className="mb-6">
              <label htmlFor="input-json" className="block text-sm font-medium text-gray-700 mb-2">
                Input JSON
              </label>
              <div className="mt-1">
                <textarea
                  id="input-json"
                  name="input-json"
                  rows={8}
                  className="shadow-sm focus:ring-blue-500 focus:border-blue-500 block w-full sm:text-sm border border-gray-300 rounded-md p-3 font-mono text-sm"
                  placeholder={"{\n  \"input1\": \"value1\",\n  \"input2\": 12345\n}"}
                  defaultValue=""
                />
              </div>
            </div>

            <div className="flex justify-end">
              <button
                type="button"
                className="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
              >
                Generate Proof
              </button>
            </div>
          </div>

          {/* Right Column - Output */}
          <div className="bg-white p-6 rounded-xl shadow-md">
            <h2 className="text-lg font-semibold text-gray-900 mb-4">Proof & Verification</h2>
            
            <div className="mb-6">
              <label htmlFor="proof" className="block text-sm font-medium text-gray-700 mb-2">
                Proof
              </label>
              <div className="mt-1">
                <textarea
                  id="proof"
                  name="proof"
                  rows={8}
                  className="shadow-sm focus:ring-blue-500 focus:border-blue-500 block w-full sm:text-sm border border-gray-300 rounded-md p-3 font-mono text-sm bg-gray-50"
                  placeholder="Proof will appear here..."
                  readOnly
                  value=""
                />
              </div>
            </div>

            <div className="mb-6">
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Verification Status
              </label>
              <div className="bg-gray-50 p-4 rounded-md border border-gray-200">
                <div className="flex items-center">
                  <div className="flex-shrink-0">
                    <svg className="h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                      <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
                    </svg>
                  </div>
                  <div className="ml-3">
                    <p className="text-sm font-medium text-gray-700">Proof not generated yet</p>
                  </div>
                </div>
              </div>
            </div>

            <div className="flex space-x-3 justify-end">
              <button
                type="button"
                className="inline-flex items-center px-4 py-2 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
              >
                Copy Proof
              </button>
              <button
                type="button"
                className="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-green-600 hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500"
              >
                Verify Proof
              </button>
            </div>
          </div>
        </div>
      </main>

      <footer className="bg-white mt-12 border-t border-gray-200">
        <div className="max-w-7xl mx-auto py-8 px-4 sm:px-6 lg:px-8">
          <p className="text-center text-sm text-gray-500">
            &copy; {new Date().getFullYear()} ZK Proof System. All rights reserved.
          </p>
        </div>
      </footer>
    </div>
  );
}
