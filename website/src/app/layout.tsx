import type { Metadata } from 'next';
import { Inter, Instrument_Serif } from 'next/font/google';
import './globals.css';
import { Navbar } from '@/components/navbar';

const inter = Inter({ 
  subsets: ['latin'],
  variable: '--font-inter',
});

const instrumentSerif = Instrument_Serif({
  subsets: ['latin'],
  variable: '--font-instrument-serif',
  weight: ['400'],
});

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
    <html lang="en" className={`${inter.variable} ${instrumentSerif.variable}`}>
      <body className="min-h-screen bg-[#F7F5F3] font-sans antialiased">
        <Navbar />
        <main className="pt-20 lg:pt-24">
          {children}
        </main>
      </body>
    </html>
  );
}
