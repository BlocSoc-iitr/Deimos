import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  // Server-side proxy: the browser only ever talks to this site (HTTPS on
  // Vercel), and Next forwards /api/* to the backend server-side. This avoids
  // mixed-content blocking when the backend is plain HTTP. Set BACKEND_ORIGIN
  // (e.g. http://<elastic-ip>) in the Vercel project env. When it's unset
  // (local dev), no rewrite is added and the pages fetch the backend directly
  // via NEXT_PUBLIC_API_URL.
  async rewrites() {
    const backend = process.env.BACKEND_ORIGIN;
    if (!backend) return [];
    return [{ source: "/api/:path*", destination: `${backend}/api/:path*` }];
  },
};

export default nextConfig;
