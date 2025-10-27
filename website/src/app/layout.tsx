import type { Metadata } from 'next';
import { Inter } from 'next/font/google';
import './globals.css';
import Link from 'next/link';

const inter = Inter({ subsets: ['latin'] });

export const metadata: Metadata = {
  title: 'Deimos - zkVM Mobile Benchmarking Suite',
  description: 'An open-source benchmarking suite for evaluating zero-knowledge virtual machines (zkVMs) on mobile devices.',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en" className="h-full bg-gray-50">
      <body className={`${inter.className} min-h-screen flex flex-col`}>
        <header className="">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
            <div className="flex justify-between items-center">
              <Link href="/" className="text-2xl font-bold text-blue-400">
                Deimos
              </Link>
            </div>
          </div>
        </header>
        
        <main className="flex-grow">
          {children}
        </main>
      </body>
    </html>
  );
}
