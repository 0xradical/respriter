const path = require("path");
const nodeExternals = require("webpack-node-externals");
const VueLoaderPlugin = require("vue-loader/lib/plugin");

module.exports = {
  target: "node",
  mode: "production",
  entry: path.join(__dirname, "app/assets/js/hypernova.js"),
  output: {
    path: path.join(__dirname, "/ssr"),
    filename: "hypernova.js",
    chunkFilename: "[name].lazy-chunk.js",
    libraryTarget: "commonjs2"
  },
  resolve: {
    alias: {
      "~~hypernova$": path.resolve(
        __dirname,
        "app/assets/js/hypernova/server.js"
      ),
      "~~dompurify$": path.resolve(
        __dirname,
        "app/assets/js/dompurify/server.js"
      ),
      "~~marked$": path.resolve(__dirname, "app/assets/js/marked.js"),
      "~~tippy$": path.resolve(__dirname, "app/assets/js/tippy.js"),
      "~~lazy-hydration$": require.resolve("vue-lazy-hydration"),
      "~~lodash$": require.resolve("lodash"),
      "~~video-service$": path.resolve(
        __dirname,
        "app/assets/js/video_service.js"
      ),
      "vue-js-modal": "vue-js-modal/dist/ssr.index",
      "~~vue-awesome-swiper": path.resolve(__dirname, "app/assets/js/empty.js"),
      components: path.resolve(__dirname, "app/assets/vue/components/src"),
      locales: path.resolve(__dirname, "config/locales")
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
        /^hypernova$/,
        /^hypernova-vue$/
      ]
    })
  ],
  module: {
    rules: [
      {
        test: /\.js$/,
        include: [path.join(__dirname, "app/assets")],
        exclude: /node_modules/,
        use: [
          {
            loader: "babel-loader"
          }
        ]
      },
      {
        test: /\.vue$/,
        use: [
          {
            loader: "vue-loader"
          }
        ]
      },
      {
        test: /\.css$/,
        use: ["vue-style-loader", "css-loader"]
      },
      {
        test: /\.scss$/,
        use: ["vue-style-loader", "css-loader", "sass-loader"]
      },
      {
        test: /\.yml$/,
        use: ["json-loader", "yaml-loader"]
      }
    ]
  },
  plugins: [new VueLoaderPlugin()]
};
