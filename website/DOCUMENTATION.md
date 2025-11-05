# Deimos Documentation Website

This is the documentation website for the Deimos zkVM Mobile Benchmarking Suite.

## Overview

The website provides comprehensive documentation for the Deimos project, covering all aspects from getting started to advanced circuit implementation and MoPro integration.

## Pages

### Main Pages

1. **Home (`/`)** - Landing page with project overview and feature highlights
2. **Documentation (`/documentation`)** - Complete project documentation including:
   - What is Deimos
   - Repository structure
   - Benchmarked frameworks and primitives
   - Measured metrics
   - Circuit implementation details
   - MoPro integration overview
   - CI/CD pipeline
   - Development status
   - Use cases
   - Resources

3. **Get Started (`/get-started`)** - Step-by-step setup guide including:
   - Prerequisites
   - Quick start instructions
   - Installing dependencies (Rust, Circom, snarkjs, MoPro CLI, Noir)
   - Working with Circom circuits
   - Setting up MoPro mobile apps
   - Project structure navigation
   - Common issues and solutions

4. **Circuits (`/circuits`)** - Circuit implementation guide covering:
   - Circuit patterns
   - Implemented circuits (SHA-256, Keccak-256, BLAKE2s, Poseidon, MiMC, Pedersen)
   - Step-by-step guide for adding new hash functions
   - Bit ordering (MSB-first vs LSB-first)
   - Common issues and troubleshooting
   - Circuit verification checklist
   - Performance optimization
   - Testing strategy

5. **MoPro (`/mopro`)** - MoPro integration documentation including:
   - What is MoPro
   - Architecture overview
   - Directory structure
   - Setting up MoPro
   - Rust implementation
   - Android integration
   - iOS integration
   - Benchmarking features
   - Circuit integration
   - Testing
   - Performance optimization
   - Common issues
   - Use cases

6. **Contributing (`/contributing`)** - Contribution guidelines covering:
   - Ways to contribute
   - Development workflow
   - Adding new applications
   - Code style guidelines
   - Testing requirements
   - Documentation requirements
   - Branch policy
   - Commit message guidelines
   - Pull request guidelines

7. **About (`/about`)** - Project information including:
   - Project overview
   - Project goals
   - Why mobile ZK benchmarking
   - Current status
   - Technology stack
   - Supported primitives
   - Community and support
   - Roadmap
   - Research applications
   - Use cases
   - Acknowledgments
   - License

8. **Benchmarks (`/benchmarks`)** - Placeholder for future benchmark dashboard

## Technology Stack

- **Framework:** Next.js 15.5.3 with Turbopack
- **Language:** TypeScript
- **Styling:** Tailwind CSS
- **Font:** Inter (Google Fonts)

## Running the Website

```bash
cd website
npm install
npm run dev
```

The website will be available at http://localhost:3000 (or next available port).

## Building for Production

```bash
npm run build
npm start
```

## Design Philosophy

The documentation website follows a simple, content-focused approach:

- **No fancy design:** Focus on information rather than aesthetics
- **Simple language:** Clear and straightforward explanations
- **Complete information:** All details in one place
- **Easy navigation:** Simple header navigation to all sections
- **Preserved theme:** Uses the existing blue and gray color scheme

## Content Organization

All documentation is organized into logical sections with:
- Clear headings and subheadings
- Code examples in gray boxes
- Lists for easy scanning
- Links to external resources
- Cross-references between pages

## Future Enhancements

Planned additions:
- Interactive benchmark dashboard
- Database integration for storing results
- Visualization components for performance data
- Search functionality
- Mobile-responsive navigation menu
- Dark mode support (optional)

## Maintenance

When updating documentation:
1. Keep information accurate and up-to-date
2. Maintain consistent formatting across pages
3. Update code examples when APIs change
4. Add new pages for new features
5. Keep the simple, content-focused approach
