import type { Config } from "tailwindcss";

const config: Config = {
  content: ["./src/app/**/*.{ts,tsx,mdx}"],
  theme: {},
  plugins: [
    require('daisyui'),
  ],
};
export default config;
