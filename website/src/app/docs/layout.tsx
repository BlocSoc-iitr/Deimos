'use client';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { useState } from 'react';

interface SidebarItem {
  title: string;
  href: string;
  children?: SidebarItem[];
}

const sidebarItems: SidebarItem[] = [
  {
    title: 'Getting Started',
    href: '/docs/getstarted',
  },
  {
    title: 'Circuits',
    href: '/docs/circuits',
  },
  {
    title: 'MoPro',
    href: '/docs/mopro',
  },
  {
    title: 'Contributing',
    href: '/docs/contributing',
  },
];

export default function DocsLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const pathname = usePathname();
  const [isSidebarOpen, setIsSidebarOpen] = useState(false);

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
          <ul className="space-y-2">
            {sidebarItems.map((item) => (
              <li key={item.href}>
                <Link
                  href={item.href}
                  className={`flex items-center p-3 rounded-lg transition-colors ${
                    pathname === item.href
                      ? 'bg-blue-600 text-white'
                      : 'text-gray-700 hover:bg-gray-200'
                  }`}
                  onClick={() => setIsSidebarOpen(false)}
                >
                  <span className="font-medium">{item.title}</span>
                </Link>
              </li>
            ))}
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
