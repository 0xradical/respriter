const { environment } = require("@rails/webpacker");
const { VueLoaderPlugin } = require("vue-loader");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const path = require("path");

const vue = require("./loaders/vue");
const yaml = require("./loaders/yaml");

environment.loaders.append("vue", vue);
environment.loaders.append("yaml", yaml);

environment.plugins.append(
  "MiniCssExtractPlugin",
  new MiniCssExtractPlugin({ filename: "[name]-[hash].css" })
);
environment.plugins.append("VueLoaderPlugin", new VueLoaderPlugin());

environment.config.merge({
  resolve: {
    modules: [process.env.NODE_PATH],
    alias: {
      vue$: "vue/dist/vue.common.js",
      Swiper$: "swiper",
      "~~hypernova$": path.resolve(
        __dirname,
        "../../app/assets/js/hypernova/client.js"
      ),
      "~~dompurify$": path.resolve(
        __dirname,
        "../../app/assets/js/dompurify/client.js"
      ),
      "~~marked$": path.resolve(__dirname, "../../app/assets/js/marked.js"),
      "~~tippy$": path.resolve(__dirname, "../../app/assets/js/tippy.js"),
      "~~lazy-hydration$": require.resolve("vue-lazy-hydration"),
      "~~lodash$": require.resolve("lodash"),
      "~~video-service$": path.resolve(
        __dirname,
        "../../app/assets/js/video_service.js"
      ),
      "~~vue-awesome-swiper": require.resolve("vue-awesome-swiper"),
      components: path.resolve(
        __dirname,
        "../../app/assets/vue/components/src"
      ),
      locales: path.resolve(__dirname, "../../config/locales")
    }
  }
});

module.exports = environment;
