const path = require("path");
const webpack = require("webpack");
const WebpackAssetsManifest = require("webpack-assets-manifest");
const { CleanWebpackPlugin } = require("clean-webpack-plugin");

module.exports = (env, argv) => {
  const config = require("../config")(env);

  return {
    resolve: {
      alias: {
        vue$: "vue/dist/vue.common.js",
        Swiper$: "swiper",
        "~~hypernova$": path.resolve(
          __dirname,
          "../../../app/assets/js/hypernova/client.js"
        ),
        "~~dompurify$": path.resolve(
          __dirname,
          "../../../app/assets/js/dompurify/client.js"
        ),
        "~~i18n$": path.resolve(
          __dirname,
          "../../../app/assets/js/i18n/client.js"
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
        "~~vue-awesome-swiper": require.resolve("vue-awesome-swiper"),
        components: path.resolve(
          __dirname,
          "../../../app/assets/vue/components/src"
        ),
        locales: path.resolve(__dirname, "../../locales")
      }
    },
    plugins: [
      new webpack.DefinePlugin({
        "process.env.VUE_ENV": '"client"'
      }),
      new WebpackAssetsManifest({
        entrypoints: true,
        writeToDisk: true,
        publicPath: config.publicPathWithoutCDN
      }),
      new CleanWebpackPlugin({
        verbose: true,
        cleanOnceBeforeBuildPatterns: ["**/*", "!hypernova*", "!hypernova/**/*"]
      })
    ],
    optimization: {
      // Split vendor and common chunks
      // https://twitter.com/wSokra/status/969633336732905474
      splitChunks: {
        chunks: "all",
        maxInitialRequests: Infinity,
        minSize: 0,
        cacheGroups: {
          external: {
            test: /[\\/]node_modules[\\/]/,
            // name: "external"
            name(module) {
              // get the name. E.g. node_modules/packageName/not/this/part.js
              // or node_modules/packageName
              const packageName = module.context.match(
                /[\\/]node_modules[\\/](.*?)([\\/]|$)/
              )[1];

              // npm package names are URL-safe, but some servers don't like @ symbols
              return `npm.${packageName.replace("@", "")}`;
            }
          }
        }
      },
      // Separate runtime chunk to enable long term caching
      // https://twitter.com/wSokra/status/969679223278505985
      runtimeChunk: "single"
    },
    node: {
      dgram: "empty",
      fs: "empty",
      net: "empty",
      tls: "empty",
      child_process: "empty"
    }
  };
};
