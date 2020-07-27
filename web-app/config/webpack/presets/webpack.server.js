const webpack = require("webpack");
const path = require("path");
const nodeExternals = require("webpack-node-externals");
const { CleanWebpackPlugin } = require("clean-webpack-plugin");

module.exports = (env, argv) => {
  return {
    target: "node",
    devtool: env.mode === "production" ? false : false,
    entry: path.join(__dirname, "../../../app/assets/js/hypernova.js"),
    output: {
      filename: "hypernova.js",
      chunkFilename: "hypernova/[name]-[hash].chunk.js",
      libraryTarget: "commonjs2"
    },
    resolve: {
      alias: {
        "~~hypernova$": path.resolve(
          __dirname,
          "../../../app/assets/js/hypernova/server.js"
        ),
        "~~dompurify$": path.resolve(
          __dirname,
          "../../../app/assets/js/dompurify/server.js"
        ),
        "~~i18n$": path.resolve(
          __dirname,
          "../../../app/assets/js/i18n/server.js"
        ),
        "~~marked$": path.resolve(
          __dirname,
          "../../../app/assets/js/marked.js"
        ),
        "~~tippy$": path.resolve(__dirname, "../../../app/assets/js/tippy.js"),
        "~~lazy-hydration$": require.resolve("vue-lazy-hydration"),
        "~~lodash$": require.resolve("lodash"),
        "~~video-service$": path.resolve(
          __dirname,
          "../../../app/assets/js/video_service.js"
        ),
        "vue-js-modal": "vue-js-modal/dist/ssr.index",
        "~~vue-awesome-swiper": path.resolve(
          __dirname,
          "../../../app/assets/js/empty.js"
        ),
        components: path.resolve(
          __dirname,
          "../../../app/assets/vue/components/src"
        ),
        locales: path.resolve(__dirname, "../../locales")
      }
    },
    externals: [
      { canvas: "commonjs canvas" },
      nodeExternals({
        whitelist: [
          /\.s?css$/,
          /\.vue$/,
          /^vue$/,
          /^vuex$/,
          /^vue-i18n$/,
          /^vue-js-modal$/,
          /^vue-multiselect$/,
          /^hypernova$/,
          /^hypernova-vue$/
        ]
      })
    ],
    plugins: [
      new webpack.DefinePlugin({
        "process.env.VUE_ENV": '"server"'
      }),
      new CleanWebpackPlugin({
        verbose: true,
        cleanOnceBeforeBuildPatterns: ["hypernova*"]
      })
    ]
  };
};
