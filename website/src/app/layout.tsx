'use client';

import { Inter, Instrument_Serif } from 'next/font/google';
import './globals.css';
import { Navbar } from '@/components/navbar';
import { usePathname } from 'next/navigation';

const inter = Inter({ 
  subsets: ['latin'],
  variable: '--font-inter',
});

const instrumentSerif = Instrument_Serif({
  subsets: ['latin'],
  variable: '--font-instrument-serif',
  weight: ['400'],
});

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const pathname = usePathname();
  const isLandingPage = pathname === '/';

  return (
    <html lang="en" className={`${inter.variable} ${instrumentSerif.variable}`}>
      <body className="min-h-screen bg-[#F7F5F3] font-sans antialiased">
        {!isLandingPage && <Navbar />}
        <main className={!isLandingPage ? "pt-20 lg:pt-24" : ""}>
          {children}
        </main>
      </body>
    </html>
  );
}
