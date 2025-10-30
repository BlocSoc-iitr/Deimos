'use client';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { useState, useEffect } from 'react';

interface SidebarItem {
  title: string;
  href?: string;
  children?: SidebarItem[];
}

const sidebarItems: SidebarItem[] = [
  {
    title: 'Getting Started',
    children: [
      { title: 'Overview', href: '/docs/getstarted' },
      { title: 'Installation', href: '/docs/getstarted#installation' },
      { title: 'Quick Start', href: '/docs/getstarted#quick-start' },
    ],
  },
  {
    title: 'Circuits',
    children: [
      { title: 'Overview', href: '/docs/circuits' },
      { title: 'SHA-256', href: '/docs/circuits#sha-256' },
      { title: 'Keccak-256', href: '/docs/circuits#keccak-256' },
      { title: 'BLAKE2s-256', href: '/docs/circuits#blake2s-256' },
      { title: 'Poseidon', href: '/docs/circuits#poseidon' },
      { title: 'MiMC-256', href: '/docs/circuits#mimc-256' },
    ],
  },
  {
    title: 'MoPro',
    children: [
      { title: 'Overview', href: '/docs/mopro' },
      { title: 'Architecture', href: '/docs/mopro#architecture' },
      { title: 'Setup', href: '/docs/mopro#setting-up-mopro' },
      { title: 'Android Integration', href: '/docs/mopro#android-integration' },
      { title: 'iOS Integration', href: '/docs/mopro#ios-integration' },
    ],
  },
  {
    title: 'Contributing',
    children: [
      { title: 'Overview', href: '/docs/contributing' },
      { title: 'Workflow', href: '/docs/contributing#development-workflow' },
      { title: 'Code Style', href: '/docs/contributing#code-style-guidelines' },
    ],
  },
];

export default function DocsLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const pathname = usePathname();
  const [isSidebarOpen, setIsSidebarOpen] = useState(false);
  const [currentHash, setCurrentHash] = useState('');
  const [expandedSections, setExpandedSections] = useState<string[]>([
    'Getting Started',
    'Circuits',
    'MoPro',
    'Contributing',
  ]);

  // Track hash changes
  useEffect(() => {
    const updateHash = () => {
      setCurrentHash(window.location.hash);
    };
    
    // Set initial hash
    updateHash();
    
    // Listen for hash changes
    window.addEventListener('hashchange', updateHash);
    
    return () => {
      window.removeEventListener('hashchange', updateHash);
    };
  }, []);

  // Update hash when pathname changes (for client-side navigation)
  useEffect(() => {
    setCurrentHash(window.location.hash);
  }, [pathname]);

  const toggleSection = (title: string) => {
    setExpandedSections((prev) =>
      prev.includes(title)
        ? prev.filter((item) => item !== title)
        : [...prev, title]
    );
  };

  return (
    <div className="flex min-h-screen">
      {/* Mobile sidebar toggle */}
      <button
        onClick={() => setIsSidebarOpen(!isSidebarOpen)}
        className="md:hidden fixed top-20 left-4 z-50 p-2 bg-blue-600 text-white rounded-lg shadow-lg"
      >
        <svg
          className="w-6 h-6"
          fill="none"
          stroke="currentColor"
          viewBox="0 0 24 24"
        >
          <path
            strokeLinecap="round"
            strokeLinejoin="round"
            strokeWidth={2}
            d="M4 6h16M4 12h16M4 18h16"
          />
        </svg>
      </button>

      {/* Sidebar */}
      <aside
        className={`${
          isSidebarOpen ? 'translate-x-0' : '-translate-x-full'
        } md:translate-x-0 fixed md:sticky top-0 left-0 z-40 w-64 h-screen transition-transform bg-gray-50 border-r border-gray-200`}
      >
        <div className="h-full px-3 py-4 overflow-y-auto">
          <div className="mb-6 px-3">
            <h2 className="text-lg font-bold text-gray-900">Documentation</h2>
          </div>
          <ul className="space-y-1">
            {sidebarItems.map((section) => {
              return (
                <li key={section.title}>
                  {/* Parent Section - Never highlighted */}
                  <button
                    onClick={() => toggleSection(section.title)}
                    className="flex items-center justify-between w-full p-3 text-left rounded-lg transition-colors text-gray-700 hover:bg-gray-200"
                  >
                    <span className="font-medium">{section.title}</span>
                    <svg
                      className={`w-4 h-4 transition-transform ${
                        expandedSections.includes(section.title) ? 'rotate-90' : ''
                      }`}
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        strokeLinecap="round"
                        strokeLinejoin="round"
                        strokeWidth={2}
                        d="M9 5l7 7-7 7"
                      />
                    </svg>
                  </button>

                  {/* Children */}
                  {expandedSections.includes(section.title) && section.children && (
                    <ul className="ml-4 mt-1 space-y-1">
                      {section.children.map((child) => {
                        // Build the full URL with hash for comparison
                        const fullUrl = pathname + currentHash;
                        const childHref = child.href || '';
                        
                        // Check if this child is active
                        const isActive = fullUrl === childHref || 
                                       (childHref.includes('#') && 
                                        pathname === childHref.split('#')[0] && 
                                        currentHash === '#' + childHref.split('#')[1]);
                        
                        return (
                          <li key={child.href}>
                            <Link
                              href={child.href || '#'}
                              className={`flex items-center p-2 pl-4 rounded-lg transition-colors text-sm ${
                                isActive
                                  ? 'bg-blue-600 text-white'
                                  : 'text-gray-600 hover:bg-gray-200'
                              }`}
                              onClick={() => {
                                setIsSidebarOpen(false);
                                // Update hash immediately when clicked
                                if (childHref.includes('#')) {
                                  const hash = '#' + childHref.split('#')[1];
                                  setCurrentHash(hash);
                                } else {
                                  setCurrentHash('');
                                }
                              }}
                            >
                              {child.title}
                            </Link>
                          </li>
                        );
                      })}
                    </ul>
                  )}
                </li>
              );
            })}
          </ul>
        </div>
      </aside>

      {/* Overlay for mobile */}
      {isSidebarOpen && (
        <div
          className="fixed inset-0 bg-black bg-opacity-50 z-30 md:hidden"
          onClick={() => setIsSidebarOpen(false)}
        />
      )}

      {/* Main content */}
      <div className="flex-1 md:ml-0">
        {children}
      </div>
    </div>
  );
}
