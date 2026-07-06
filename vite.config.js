import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

export default defineConfig({
  plugins: [react()],
  // Base relatif ('./') supaya build ini bisa langsung di-serve dari
  // https://<user>.github.io/<nama-repo>/ tanpa perlu diubah lagi.
  base: "./",
});
