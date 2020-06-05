const webpack = require("webpack");

module.exports = (env, argv) => {
  const config = require("./config")(env);

  return {
    mode: "development",
    devtool: "cheap-module-source-map",
    output: {
      pathinfo: true
    },
    devServer: {
      clientLogLevel: "none",
      writeToDisk: false,
      compress: true,
      quiet: false,
      disableHostCheck: true,
      host: process.env.WEBPACK_DEV_SERVER_HOST,
      port: process.env.WEBPACK_DEV_SERVER_PORT,
      https: false,
      hot: true,
      // Inline should be set to true if using HMR
      inline: true,
      useLocalIp: false,
      public: process.env.WEBPACK_DEV_SERVER_PUBLIC,
      contentBase: config.outputPath,
      publicPath: config.publicPath,
      historyApiFallback: {
        disableDotRule: true
      },
      headers: { "Access-Control-Allow-Origin": "*" },
      overlay: true,
      stats: {
        entrypoints: false,
        errorDetails: true,
        modules: false,
        moduleTrace: false
      },
      watchOptions: {
        ignored: /node_modules/
      }
    },
    plugins: [new webpack.HotModuleReplacementPlugin()]
  };
};
