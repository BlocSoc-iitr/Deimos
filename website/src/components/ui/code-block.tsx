'use client';

import { useState } from 'react';

interface CodeBlockProps {
  children: string;
  language?: string;
  className?: string;
}

export function CodeBlock({ children, language, className = '' }: CodeBlockProps) {
  const [copied, setCopied] = useState(false);

  const handleCopy = async () => {
    try {
      await navigator.clipboard.writeText(children);
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    } catch (err) {
      console.error('Failed to copy text: ', err);
    }
  };

  return (
    <div className={`relative group ${className}`}>
      <div className="bg-gray-50 border border-gray-200 rounded-lg overflow-hidden">
        <div className="flex items-center justify-between px-4 py-2 bg-gray-100 border-b border-gray-200">
          {language && (
            <span className="text-xs font-medium text-gray-600 uppercase tracking-wide">
              {language}
            </span>
          )}
          <button
            onClick={handleCopy}
            className="flex items-center gap-1.5 px-2 py-1 text-xs font-medium text-gray-600 hover:text-gray-900 hover:bg-gray-200 rounded transition-colors"
            title={copied ? 'Copied!' : 'Copy to clipboard'}
          >
            {copied ? (
              <>
                <svg className="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
                </svg>
                Copied!
              </>
            ) : (
              <>
                <svg className="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z" />
                </svg>
                Copy
              </>
            )}
          </button>
        </div>
        <div className="p-4">
          <pre className="text-sm overflow-x-auto text-gray-800 whitespace-pre-wrap">
            <code>{children}</code>
          </pre>
        </div>
      </div>
    </div>
  );
}

// Enhanced version with syntax highlighting support
interface EnhancedCodeBlockProps extends CodeBlockProps {
  title?: string;
  showLineNumbers?: boolean;
}

export function EnhancedCodeBlock({ 
  children, 
  language, 
  title, 
  showLineNumbers = false,
  className = '' 
}: EnhancedCodeBlockProps) {
  const [copied, setCopied] = useState(false);

  const handleCopy = async () => {
    try {
      await navigator.clipboard.writeText(children);
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    } catch (err) {
      console.error('Failed to copy text: ', err);
    }
  };

  const lines = children.split('\n');

  return (
    <div className={`relative group ${className}`}>
      <div className="bg-[#0f1419] border border-gray-700 rounded-lg overflow-hidden shadow-lg">
        <div className="flex items-center justify-between px-4 py-3 bg-[#1a1f2e] border-b border-gray-700">
          <div className="flex items-center gap-3">
            <div className="flex gap-1.5">
              <div className="w-3 h-3 rounded-full bg-[#ff5f57]"></div>
              <div className="w-3 h-3 rounded-full bg-[#ffbd2e]"></div>
              <div className="w-3 h-3 rounded-full bg-[#28ca42]"></div>
            </div>
            {(title || language) && (
              <span className="text-sm font-medium text-gray-300">
                {title || language}
              </span>
            )}
          </div>
          <button
            onClick={handleCopy}
            className="flex items-center gap-1.5 px-3 py-1.5 text-xs font-medium text-gray-400 hover:text-white hover:bg-gray-700 rounded transition-colors"
            title={copied ? 'Copied!' : 'Copy to clipboard'}
          >
            {copied ? (
              <>
                <svg className="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
                </svg>
                Copied!
              </>
            ) : (
              <>
                <svg className="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z" />
                </svg>
                Copy
              </>
            )}
          </button>
        </div>
        <div className="relative">
          <pre className="p-4 text-sm overflow-x-auto text-gray-100 bg-[#0f1419]">
            <code className="block">
              {showLineNumbers ? (
                lines.map((line, index) => (
                  <div key={index} className="flex">
                    <span className="select-none text-gray-500 text-right pr-4 w-8 flex-shrink-0">
                      {index + 1}
                    </span>
                    <span className="flex-1">{line}</span>
                  </div>
                ))
              ) : (
                children
              )}
            </code>
          </pre>
        </div>
      </div>
    </div>
  );
}
