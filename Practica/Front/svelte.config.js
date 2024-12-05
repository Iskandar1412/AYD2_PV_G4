import { sveltePreprocess } from "svelte-preprocess";

const config = {
  preprocess: sveltePreprocess({
    scss: {},
  }),
};

export default config;