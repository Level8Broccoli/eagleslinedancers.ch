import { defineConfig } from 'astro/config';

// https://astro.build/config
export default defineConfig({
  image: {
    domains: [
      "admin.eagleslinedancers.ch",
      "eagleslinedancers.ch"
    ],
    remotePatterns: [
      { protocol: "https" }
    ],
  }
});
