import { fileURLToPath, URL } from "node:url";

import { defineConfig } from "vite";
import vue from "@vitejs/plugin-vue";

import svgLoader from "vite-svg-loader";

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [vue(), svgLoader()],
  resolve: {
    alias: {
      "@": fileURLToPath(new URL("./src", import.meta.url)),
    },
  },
});

// export default ({ mode }) => {
//   // Load app-level env vars to node-level env vars.
//   process.env = {...process.env, ...loadEnv(mode, process.cwd())};

//   return defineConfig({
//     // To access env vars here use process.env.TEST_VAR
//     plugins: [vue(), svgLoader()],
//     resolve: {
//       alias: {
//         "@": fileURLToPath(new URL("./src", import.meta.url)),
//       },
//     },
//     auth_token: process.env.VITE_AUTH_TOKEN
//   });
// }
