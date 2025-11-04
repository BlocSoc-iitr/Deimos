'use client';

export default function Contributing() {
  return (
    <div className="max-w-4xl mx-auto px-4 py-12">
      
      <h1 className="text-4xl font-bold mb-8">Contributing to Deimos</h1>
      
      <section id="overview" className="mb-12">
        <p className="mb-4 text-lg">
          We really appreciate and value contributions to Deimos. Please take time to review the items listed 
          below to make sure that your contributions are merged as soon as possible.
        </p>
        <p className="mb-4">
          Before starting development, contributors should create an issue to open discussion, validate that the PR is wanted, and coordinate implementation details.
        </p>
        <p className="mb-4">
          <strong>GitHub Issues:</strong>{' '}
          <a 
            href="https://github.com/BlocSoc-iitr/Deimos/issues/new/choose" 
            className="text-blue-600 hover:underline"
            target="_blank"
            rel="noopener noreferrer"
          >
            https://github.com/BlocSoc-iitr/Deimos/issues/new/choose
          </a>
        </p>
      </section>

      <section id="ways-to-contribute" className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Ways to Contribute</h2>
        
        <h3 className="text-xl font-bold mb-2">Add New Circuits</h3>
        <ul className="list-disc ml-6 mb-4">
          <li>Implement new hash functions (BLAKE3, SHA3-512, etc.)</li>
          <li>Add signature schemes (EdDSA, ECDSA)</li>
          <li>Create application-level circuits (JWT parsing, etc.)</li>
          <li>Optimize existing circuit implementations</li>
          <li>Implement Noir circuits</li>
        </ul>

        <h3 className="text-xl font-bold mb-2">Integrate New Frameworks</h3>
        <ul className="list-disc ml-6 mb-4">
          <li>Add support for imp1</li>
          <li>Add support for ProveKit</li>
          <li>Add support for RISC Zero</li>
          <li>Add support for SP1</li>
        </ul>

        <h3 className="text-xl font-bold mb-2">Improve Mobile Apps</h3>
        <ul className="list-disc ml-6 mb-4">
          <li>Enhance UI/UX of benchmarking apps</li>
          <li>Add more detailed metrics collection</li>
          <li>Create iOS implementations</li>
        </ul>

        <h3 className="text-xl font-bold mb-2">Enhance Documentation</h3>
        <ul className="list-disc ml-6 mb-4">
          <li>Improve setup guides</li>
          <li>Add tutorials and examples</li>
          <li>Document best practices</li>
          <li>Create video walkthroughs</li>
          <li>Translate documentation</li>
        </ul>

        <h3 className="text-xl font-bold mb-2">Build Dashboard Features</h3>
        <ul className="list-disc ml-6 mb-4">
          <li>Create visualization components</li>
          <li>Add comparison tools</li>
          <li>Build result export features</li>
        </ul>

        <h3 className="text-xl font-bold mb-2">Report Issues</h3>
        <ul className="list-disc ml-6 mb-4">
          <li>Bug reports with detailed reproduction steps</li>
          <li>Performance issues</li>
          <li>Documentation gaps or errors</li>
          <li>Feature requests</li>
        </ul>
      </section>

      <section id="development-workflow" className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Development Workflow</h2>
        
        <h3 className="text-xl font-bold mb-2">1. Fork and Clone</h3>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`# Fork the repository on GitHub
# Then clone your fork
git clone https://github.com/YOUR_USERNAME/Deimos.git
cd Deimos

# Add upstream remote
git remote add upstream https://github.com/BlocSoc-iitr/Deimos.git`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2">2. Keep Your Fork Updated</h3>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`# Fetch latest changes from upstream
git fetch upstream

# Update your local dev branch
git checkout dev
git pull --rebase upstream dev`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2">3. Create a Feature Branch</h3>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`# Branch from dev
git checkout dev
git checkout -b fix/some-bug-short-description-123

# Or for features
git checkout -b feature/new-feature-description-123

# Note: Postfixing 123 associates your PR with issue #123`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2">4. Make Your Changes</h3>
        <ul className="list-disc ml-6 mb-4">
          <li>Write clean, readable code</li>
          <li>Follow existing code style and conventions</li>
          <li>Add tests for new functionality</li>
          <li>Update documentation as needed</li>
          <li>Keep commits focused and atomic</li>
        </ul>

        <h3 className="text-xl font-bold mb-2">5. Test Your Changes</h3>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`# For Rust code
cd your-app-location
cargo fmt --all -- --check
cargo clippy --all-targets --all-features -- -D warnings
cargo test

# For circuits
circom your_circuit.circom --r1cs --wasm --sym
snarkjs groth16 fullprove input.json circuit.wasm circuit.zkey proof.json public.json

# For website
cd website
npm run build
npm run lint

# Check for typos
typos`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2">6. Commit and Push</h3>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`# Stage your changes
git add .

# Commit with descriptive message
git commit -m "Fix: short description #123"

# Push to your fork
git push origin -u fix/some-bug-short-description-123`}
          </pre>
        </div>

        <h3 className="text-xl font-bold mb-2">7. Create Pull Request</h3>
        <ul className="list-disc ml-6 mb-4">
          <li>Go to https://github.com/BlocSoc-iitr/Deimos</li>
          <li>Click &quot;New Pull Request&quot;</li>
          <li>Select your branch</li>
          <li>Begin the body with &quot;Fixes #123&quot; or &quot;Resolves #123&quot;</li>
          <li>Provide clear description of changes</li>
          <li>Include screenshots for UI changes</li>
          <li>List any breaking changes</li>
        </ul>

        <h3 className="text-xl font-bold mb-2">8. Address Review Feedback</h3>
        <p className="mb-4">
          Maintainers will review your code and may request changes. Please pay attention to feedback 
          as it&apos;s necessary to maintain code quality standards.
        </p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`# Make requested changes
git add modified_files
git commit -m "Address review feedback"
git push origin fix/some-bug-short-description-123`}
          </pre>
        </div>
      </section>

      <section id="adding-new-applications" className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Adding New Applications</h2>
        <p className="mb-4">
          When adding a new mobile application, follow the Application Integration Guide:
        </p>
        <ul className="list-disc ml-6 mb-4">
          <li>Use the MoPro framework for consistency</li>
          <li>Follow the directory structure of existing apps</li>
          <li>Include comprehensive README with setup instructions</li>
          <li>Add test vectors for your circuits</li>
          <li>Document benchmark results</li>
        </ul>
      </section>

      <section id="code-style-guidelines" className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Code Style Guidelines</h2>
        
        <h3 className="text-xl font-bold mb-2">Rust Code</h3>
        <ul className="list-disc ml-6 mb-4">
          <li>Use <code>cargo fmt</code> for formatting</li>
          <li>Address all <code>cargo clippy</code> warnings</li>
          <li>Write descriptive variable and function names</li>
          <li>Add doc comments for public APIs</li>
          <li>Keep functions focused and small</li>
        </ul>

        <h3 className="text-xl font-bold mb-2">Circom Circuits</h3>
        <ul className="list-disc ml-6 mb-4">
          <li>Use pragma circom 2.0.0 or higher</li>
          <li>Add comments explaining circuit logic</li>
          <li>Follow naming conventions from existing circuits</li>
          <li>Include template documentation</li>
          <li>Use meaningful signal names</li>
        </ul>

        <h3 className="text-xl font-bold mb-2">TypeScript/JavaScript</h3>
        <ul className="list-disc ml-6 mb-4">
          <li>Use TypeScript for type safety</li>
          <li>Follow ESLint rules</li>
          <li>Use functional components in React</li>
          <li>Keep components small and focused</li>
          <li>Add prop types and interfaces</li>
        </ul>

        <h3 className="text-xl font-bold mb-2">Kotlin (Android)</h3>
        <ul className="list-disc ml-6 mb-4">
          <li>Follow Kotlin coding conventions</li>
          <li>Use Material Design components</li>
          <li>Implement proper error handling</li>
          <li>Add KDoc comments for public APIs</li>
          <li>Use coroutines for async operations</li>
        </ul>

        <h3 className="text-xl font-bold mb-2">Swift (iOS)</h3>
        <ul className="list-disc ml-6 mb-4">
          <li>Follow Swift API design guidelines</li>
          <li>Use SwiftUI or UIKit consistently</li>
          <li>Implement proper error handling</li>
          <li>Add documentation comments</li>
          <li>Use async/await for async operations</li>
        </ul>
      </section>

      <section id="testing-requirements" className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Testing Requirements</h2>
        
        <h3 className="text-xl font-bold mb-2">Circuit Testing</h3>
        <ul className="list-disc ml-6 mb-4">
          <li>Test with known test vectors</li>
          <li>Verify output matches reference implementation</li>
          <li>Test proof generation and verification</li>
          <li>Document constraint count</li>
        </ul>

        <h3 className="text-xl font-bold mb-2">Code Testing</h3>
        <ul className="list-disc ml-6 mb-4">
          <li>Write unit tests for new functions</li>
          <li>Add integration tests for features</li>
          <li>Test error handling paths</li>
          <li>Verify edge cases</li>
          <li>Maintain or improve code coverage</li>
        </ul>

        <h3 className="text-xl font-bold mb-2">Mobile Testing</h3>
        <ul className="list-disc ml-6 mb-4">
          <li>Test on physical devices</li>
          <li>Test on multiple device models</li>
          <li>Test on different OS versions</li>
          <li>Test performance under load</li>
        </ul>
      </section>

      <section id="documentation-requirements" className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Documentation Requirements</h2>
        <ul className="list-disc ml-6 mb-4">
          <li>Update README if adding new features</li>
          <li>Add inline code comments for complex logic</li>
          <li>Document API changes</li>
          <li>Include usage examples</li>
          <li>Update relevant guides</li>
          <li>Add screenshots for UI changes</li>
        </ul>
      </section>

      <section id="git-guidelines" className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Git Guidelines</h2>
        
        <h3 className="text-xl font-bold mb-2">Branch Policy</h3>
        <ul className="list-disc ml-6 mb-4">
          <li><strong>main:</strong> Stable releases only. Do not submit PRs directly to main.</li>
          <li><strong>dev:</strong> Active development branch. Submit all PRs to dev.</li>
          <li><strong>feature/*:</strong> Feature branches for new functionality</li>
          <li><strong>fix/*:</strong> Bug fix branches</li>
          <li><strong>docs/*:</strong> Documentation improvement branches</li>
        </ul>

        <h3 className="text-xl font-bold mb-2 mt-6">Commit Message Guidelines</h3>
        <p className="mb-4">Write clear, descriptive commit messages:</p>
        <div className="bg-gray-50 p-4 rounded mb-4">
          <pre className="text-sm overflow-x-auto">
{`# Good commit messages
Add Keccak-256 circuit implementation #45
Fix memory leak in proof generation #67
Update MoPro integration guide
Optimize SHA-256 constraint count

# Bad commit messages
fix bug
update
changes
wip`}
          </pre>
        </div>
        <p className="mb-4">Format:</p>
        <ul className="list-disc ml-6 mb-4">
          <li>Use imperative mood (&quot;Add&quot; not &quot;Added&quot;)</li>
          <li>Keep first line under 72 characters</li>
          <li>Reference issue numbers</li>
          <li>Be specific about what changed</li>
        </ul>

        <h3 className="text-xl font-bold mb-2 mt-6">Pull Request Guidelines</h3>
        
        <h4 className="text-lg font-bold mb-2 mt-4">PR Title</h4>
        <ul className="list-disc ml-6 mb-4">
          <li>Clear and descriptive</li>
          <li>Reference issue number</li>
          <li>Use imperative mood</li>
        </ul>

        <h4 className="text-lg font-bold mb-2 mt-4">PR Description</h4>
        <p className="mb-4">Include:</p>
        <ul className="list-disc ml-6 mb-4">
          <li>What changes were made</li>
          <li>Why the changes were necessary</li>
          <li>How to test the changes</li>
          <li>Screenshots for UI changes</li>
          <li>Breaking changes (if any)</li>
          <li>Related issues</li>
        </ul>

        <h4 className="text-lg font-bold mb-2 mt-4">PR Checklist</h4>
        <ul className="list-disc ml-6 mb-4">
          <li>Code follows project style guidelines</li>
          <li>Tests pass locally</li>
          <li>New tests added for new functionality</li>
          <li>Documentation updated</li>
          <li>No merge conflicts</li>
          <li>Commits are clean and focused</li>
          <li>PR is linked to relevant issue</li>
        </ul>
      </section>

      <section id="getting-help" className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Getting Help</h2>
        <p className="mb-4">If you need help with your contribution:</p>
        <ul className="list-disc ml-6 mb-4">
          <li>Check existing documentation and guides</li>
          <li>Look at similar implementations in the codebase</li>
          <li>Ask questions in your issue or PR</li>
          <li>Join community discussions</li>
          <li>Reach out to maintainers</li>
        </ul>
      </section>


      <section id="code-of-conduct" className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Code of Conduct</h2>
        <p className="mb-4">
          Be respectful and inclusive. We want to maintain a welcoming environment for all contributors.
        </p>
        <ul className="list-disc ml-6 mb-4">
          <li>Be respectful of differing opinions</li>
          <li>Accept constructive criticism gracefully</li>
          <li>Focus on what is best for the community</li>
          <li>Show empathy towards other community members</li>
        </ul>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">License</h2>
        <p className="mb-4">
          By contributing to Deimos, you agree that your contributions will be licensed under the MIT License.
        </p>
      </section>

      <section className="mb-12">
        <h2 className="text-2xl font-bold mb-4">Thank You!</h2>
        <p className="mb-4">
          Thank you for taking the time to contribute to Deimos. Your contributions help make mobile ZK 
          proving better for everyone!
        </p>
      </section>
    </div>
  );
}
