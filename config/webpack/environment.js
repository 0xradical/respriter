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
    alias: {
      vue$: "vue/dist/vue.common.js",
      jsdom: path.resolve(__dirname, "../../app/assets/js/dummy/jsdom.js"),
      "hypernova-renderer$": path.resolve(
        __dirname,
        "../../app/assets/js/hypernova/client.js"
      )
    }
  }
});

module.exports = environment;
