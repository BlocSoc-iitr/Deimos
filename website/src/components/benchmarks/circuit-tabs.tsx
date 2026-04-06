'use client'

import { Tabs, TabsList, TabsTrigger } from '@/components/ui/tabs'
import { cn } from '@/lib/utils'

interface CircuitTabsProps {
  families: string[]
  selectedFamily: string
  onFamilyChange: (family: string) => void
  languages: string[]
  selectedLanguage: string
  onLanguageChange: (language: string) => void
  inputSizes: number[]
  selectedInputSize: number
  onInputSizeChange: (size: number) => void
  unit: string
}

/** Capitalises the first letter and uppercases known acronyms. */
function formatFamilyName(family: string): string {
  const upper: Record<string, string> = {
    sha256: 'SHA256',
    sha512: 'SHA512',
    keccak256: 'Keccak256',
    blake2: 'Blake2',
    blake3: 'Blake3',
    poseidon: 'Poseidon',
    poseidon2: 'Poseidon2',
    mimc: 'MiMC',
    anemoi: 'Anemoi',
    pedersen: 'Pedersen',
    rescue_prime: 'RescuePrime',
  }
  return upper[family.toLowerCase()] ?? family.charAt(0).toUpperCase() + family.slice(1)
}

export function CircuitTabs({
  families,
  selectedFamily,
  onFamilyChange,
  languages,
  selectedLanguage,
  onLanguageChange,
  inputSizes,
  selectedInputSize,
  onInputSizeChange,
  unit,
}: CircuitTabsProps) {
  if (families.length === 0) return null

  return (
    <div className="space-y-3">
      {/* Family selector */}
      <Tabs value={selectedFamily} onValueChange={onFamilyChange}>
        <TabsList className="h-auto flex-wrap gap-1 bg-[#F7F5F3] p-1">
          {families.map((family) => (
            <TabsTrigger
              key={family}
              value={family}
              className="rounded px-3 py-1.5 text-xs font-medium data-[state=active]:bg-white data-[state=active]:text-[#37322F] data-[state=active]:shadow-sm"
            >
              {formatFamilyName(family)}
            </TabsTrigger>
          ))}
        </TabsList>
      </Tabs>

      {/* Framework (proving backend) selector */}
      {languages.length > 1 && (
        <div className="flex flex-wrap items-center gap-2">
          <span className="text-xs text-[#605A57]">Framework:</span>
          {languages.map((lang) => (
            <button
              key={lang}
              onClick={() => onLanguageChange(lang)}
              className={cn(
                'rounded border px-2.5 py-0.5 text-xs font-medium transition-colors',
                selectedLanguage === lang
                  ? 'border-[#37322F] bg-[#37322F] text-white'
                  : 'border-[#E0DEDB] bg-white text-[#37322F] hover:bg-[#F7F5F3]',
              )}
            >
              {lang}
            </button>
          ))}
        </div>
      )}

      {/* Input size picker — shown when at least one size is available */}
      {inputSizes.length >= 1 && (
        <div className="flex flex-wrap items-center gap-2">
          <span className="text-xs text-[#605A57]">Input size:</span>
          {inputSizes.map((size) => (
            <button
              key={size}
              onClick={() => onInputSizeChange(size)}
              className={cn(
                'rounded border px-2.5 py-0.5 text-xs font-medium transition-colors',
                selectedInputSize === size
                  ? 'border-[#37322F] bg-[#37322F] text-white'
                  : 'border-[#E0DEDB] bg-white text-[#37322F] hover:bg-[#F7F5F3]',
              )}
            >
              {size} {unit}
            </button>
          ))}
        </div>
      )}
    </div>
  )
}
