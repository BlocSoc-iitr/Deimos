import Link from "next/link";

export const metadata = {
  title: "Privacy Policy | Deimos",
  description: "Privacy policy for the Deimos mobile benchmarking application.",
};

export default function PrivacyPolicyPage() {
  return (
    <article className="mx-auto max-w-3xl px-6 py-16 text-[#37322F] sm:py-24">
      <Link href="/" className="text-sm font-medium text-[#605A57] hover:text-[#37322F]">
        ← Back to Deimos
      </Link>

      <header className="mt-10 border-b border-[rgba(55,50,47,0.12)] pb-10">
        <p className="text-sm font-medium text-[#605A57]">Last updated: September 9, 2026</p>
        <h1 className="mt-3 font-serif text-5xl leading-tight sm:text-6xl">Privacy Policy</h1>
        <p className="mt-6 text-lg leading-8 text-[#605A57]">
          This policy explains how Deimos handles information generated when you run
          zero-knowledge proving benchmarks on the Deimos mobile application.
        </p>
      </header>

      <div className="mt-12 space-y-10 text-base leading-7 text-[#49423D]">
        <section>
          <h2 className="text-2xl font-semibold text-[#37322F]">Who operates Deimos</h2>
          <p className="mt-3">
            Deimos is operated by Blockchain Society, IIT Roorkee (BlocSoc IITR). This
            policy applies to the Deimos mobile app and its benchmark-results service.
          </p>
        </section>

        <section>
          <h2 className="text-2xl font-semibold text-[#37322F]">Information we collect</h2>
          <p className="mt-3">
            When a benchmark completes, the app sends its benchmark result to the
            Deimos backend. That result can include:
          </p>
          <ul className="mt-3 list-disc space-y-2 pl-6">
            <li>device platform, model, manufacturer, operating-system version, and a device identifier;</li>
            <li>device and process performance measurements, including memory, CPU usage, and battery temperature;</li>
            <li>the benchmark&apos;s circuit, framework, input size, proof size, proving and verification times, and timestamp; and</li>
            <li>benchmark input values you choose to run.</li>
          </ul>
          <p className="mt-3">
            Do not enter personal, confidential, or sensitive information as benchmark input.
          </p>
        </section>

        <section>
          <h2 className="text-2xl font-semibold text-[#37322F]">How we use this information</h2>
          <p className="mt-3">
            We use benchmark data to operate Deimos, compare proving-system performance
            on mobile hardware, display benchmark results, and improve the project. The
            device identifier is used to group repeat runs of the same benchmark on the
            same device into an aggregate result.
          </p>
        </section>

        <section>
          <h2 className="text-2xl font-semibold text-[#37322F]">Storage, sharing, and security</h2>
          <p className="mt-3">
            Benchmark results are stored in the Deimos backend. We do not sell benchmark
            data or use it for advertising. We may use service providers that host or
            operate the backend solely to provide the service. Production benchmark
            uploads are sent over HTTPS.
          </p>
        </section>

        <section>
          <h2 className="text-2xl font-semibold text-[#37322F]">Retention and deletion</h2>
          <p className="mt-3">
            We retain benchmark results while they are useful for the Deimos benchmarking
            dataset and project operations. To request deletion of records associated with
            your device, email us with the subject “Deimos privacy request” and include
            the device identifier shown by the app, if available. We will delete or
            anonymize the matching records unless we need to retain them for security,
            legal, or operational reasons.
          </p>
        </section>

        <section>
          <h2 className="text-2xl font-semibold text-[#37322F]">Changes and contact</h2>
          <p className="mt-3">
            We may update this policy as Deimos changes. The current version is always
            available at this page. For privacy questions or requests, contact{" "}
            <a className="underline underline-offset-4 hover:text-[#37322F]" href="mailto:blocsoc.acm@iitr.ac.in">
              blocsoc.acm@iitr.ac.in
            </a>.
          </p>
        </section>
      </div>
    </article>
  );
}
