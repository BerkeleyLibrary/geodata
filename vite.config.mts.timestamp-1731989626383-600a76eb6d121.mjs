// vite.config.mts
import { defineConfig, searchForWorkspaceRoot } from "file:///opt/app/node_modules/vite/dist/node/index.js";
import rails from "file:///opt/app/node_modules/vite-plugin-rails/dist/index.js";
var vite_config_default = defineConfig(({ mode }) => {
  return {
    build: {
      minify: mode === "production",
      manifest: true,
      sourcemap: true
    },
    server: {
      fs: {
        allow: [
          // search up for workspace root
          searchForWorkspaceRoot(process.cwd()),
          // One directory up (from .internal_test_app where we do `yarn link @geoblacklight`)
          `${process.cwd()}/..`
        ]
      }
    },
    plugins: [rails()]
  };
});
export {
  vite_config_default as default
};
//# sourceMappingURL=data:application/json;base64,ewogICJ2ZXJzaW9uIjogMywKICAic291cmNlcyI6IFsidml0ZS5jb25maWcubXRzIl0sCiAgInNvdXJjZXNDb250ZW50IjogWyJjb25zdCBfX3ZpdGVfaW5qZWN0ZWRfb3JpZ2luYWxfZGlybmFtZSA9IFwiL29wdC9hcHBcIjtjb25zdCBfX3ZpdGVfaW5qZWN0ZWRfb3JpZ2luYWxfZmlsZW5hbWUgPSBcIi9vcHQvYXBwL3ZpdGUuY29uZmlnLm10c1wiO2NvbnN0IF9fdml0ZV9pbmplY3RlZF9vcmlnaW5hbF9pbXBvcnRfbWV0YV91cmwgPSBcImZpbGU6Ly8vb3B0L2FwcC92aXRlLmNvbmZpZy5tdHNcIjtpbXBvcnQgeyBkZWZpbmVDb25maWcsIHNlYXJjaEZvcldvcmtzcGFjZVJvb3QgfSBmcm9tIFwidml0ZVwiO1xuaW1wb3J0IHJhaWxzIGZyb20gXCJ2aXRlLXBsdWdpbi1yYWlsc1wiO1xuXG5leHBvcnQgZGVmYXVsdCBkZWZpbmVDb25maWcoKHsgbW9kZSB9KSA9PiB7XG4gIHJldHVybiB7XG4gICAgYnVpbGQ6IHtcbiAgICAgIG1pbmlmeTogbW9kZSA9PT0gXCJwcm9kdWN0aW9uXCIsXG4gICAgICBtYW5pZmVzdDogdHJ1ZSxcbiAgICAgIHNvdXJjZW1hcDogdHJ1ZSxcbiAgICB9LFxuICAgIHNlcnZlcjoge1xuICAgICAgZnM6IHtcbiAgICAgICAgYWxsb3c6IFtcbiAgICAgICAgICAvLyBzZWFyY2ggdXAgZm9yIHdvcmtzcGFjZSByb290XG4gICAgICAgICAgc2VhcmNoRm9yV29ya3NwYWNlUm9vdChwcm9jZXNzLmN3ZCgpKSxcbiAgICAgICAgICAvLyBPbmUgZGlyZWN0b3J5IHVwIChmcm9tIC5pbnRlcm5hbF90ZXN0X2FwcCB3aGVyZSB3ZSBkbyBgeWFybiBsaW5rIEBnZW9ibGFja2xpZ2h0YClcbiAgICAgICAgICBgJHtwcm9jZXNzLmN3ZCgpfS8uLmAsXG4gICAgICAgIF0sXG4gICAgICB9LFxuICAgIH0sXG4gICAgcGx1Z2luczogW3JhaWxzKCldLFxuICB9O1xufSk7XG4iXSwKICAibWFwcGluZ3MiOiAiO0FBQTRNLFNBQVMsY0FBYyw4QkFBOEI7QUFDalEsT0FBTyxXQUFXO0FBRWxCLElBQU8sc0JBQVEsYUFBYSxDQUFDLEVBQUUsS0FBSyxNQUFNO0FBQ3hDLFNBQU87QUFBQSxJQUNMLE9BQU87QUFBQSxNQUNMLFFBQVEsU0FBUztBQUFBLE1BQ2pCLFVBQVU7QUFBQSxNQUNWLFdBQVc7QUFBQSxJQUNiO0FBQUEsSUFDQSxRQUFRO0FBQUEsTUFDTixJQUFJO0FBQUEsUUFDRixPQUFPO0FBQUE7QUFBQSxVQUVMLHVCQUF1QixRQUFRLElBQUksQ0FBQztBQUFBO0FBQUEsVUFFcEMsR0FBRyxRQUFRLElBQUksQ0FBQztBQUFBLFFBQ2xCO0FBQUEsTUFDRjtBQUFBLElBQ0Y7QUFBQSxJQUNBLFNBQVMsQ0FBQyxNQUFNLENBQUM7QUFBQSxFQUNuQjtBQUNGLENBQUM7IiwKICAibmFtZXMiOiBbXQp9Cg==
