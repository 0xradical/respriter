const path = require("path");

module.exports = {
  lintOnSave: process.env.LINT_ON_SAVE === "true",
  configureWebpack: {
    resolve: {
      alias: {
        "~~dompurify$": path.resolve(__dirname, "src/vendor/dompurify.js"),
        "~~marked$": path.resolve(__dirname, "src/vendor/marked.js"),
        "~~tippy$": path.resolve(__dirname, "src/vendor/tippy.js"),
        // "~~lazy-hydration$": require.resolve("vue-lazy-hydration"),
        // "~~lazy-hydration$": path.resolve(__dirname, "src/vendor/empty.js"),
        "~~lodash$": require.resolve("lodash"),
        "~external": path.resolve("src/components/external/src"),
        "~utils": path.resolve("src/lib/utils"),
        "~validations": path.resolve("src/lib/validations"),
        "~store": path.resolve("src/store"),
        "~components": path.resolve("src/components"),
        "~config": path.resolve("src/config")
      }
    },
    module: {
      rules: [
        {
          test: /\.yml$/,
          use: ["json-loader", "yaml-loader"]
        }
      ]
    }
  },
  chainWebpack: config => {
    config.module
      .rule("vue")
      .use("vue-loader")
      .loader("vue-loader")
      .tap(options => {
        options.compilerOptions.whitespace = "preserve";
        return options;
      });
  },
  devServer: {
    disableHostCheck: true,
    host: "0.0.0.0",
    allowedHosts: [".lvh.me", "localhost"]
  }
};