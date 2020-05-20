const path = require("path");
const webpack = require("webpack");
const HtmlWebpackPlugin = require("html-webpack-plugin");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const VueLoaderPlugin = require("vue-loader/lib/plugin");

module.exports = () => {
  return {
    entry: {
      scratchpad: path.resolve(__dirname, "../scratchpad/index.js")
    },
    devtool: "cheap-module-eval-source-map",
    devServer: {
      allowedHosts: ["localhost", "127.0.0.1"],
      disableHostCheck: true,
      host: "0.0.0.0",
      headers: {
        "Access-Control-Allow-Origin": "*"
      },
      overlay: true,
      port: 8080
    },
    resolve: {
      alias: {
        "~~dompurify$": path.resolve(
          __dirname,
          "../scratchpad/js/dompurify.js"
        ),
        "~~marked$": path.resolve(__dirname, "../scratchpad/js/marked.js"),
        "~~tippy$": path.resolve(__dirname, "../scratchpad/js/tippy.js"),
        "~~video-service$": path.resolve(
          __dirname,
          "../scratchpad/js/video-service.js"
        ),
        "~~lazy-hydration$": require.resolve("vue-lazy-hydration"),
        "~~lodash$": require.resolve("lodash"),
        i18n: path.resolve(__dirname, "../i18n"),
        components: path.resolve(__dirname, "../src")
      }
    },
    module: {
      rules: [
        {
          test: /\.(sa|sc|c)ss$/,
          use: [
            {
              loader: MiniCssExtractPlugin.loader
            },
            {
              loader: "css-loader",
              options: {
                modules: false
              }
            },
            {
              loader: "postcss-loader"
            },
            {
              loader: "sass-loader"
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
          test: /\.yml$/,
          use: ["json-loader", "yaml-loader"]
        }
      ]
    },
    plugins: [
      new webpack.DefinePlugin({
        VUE_APP_ELEMENTS_HOST: JSON.stringify(
          process.env.VUE_APP_ELEMENTS_HOST
        ),
        VUE_APP_ELEMENTS_VERSION: JSON.stringify(
          process.env.VUE_APP_ELEMENTS_VERSION
        )
      }),
      new MiniCssExtractPlugin({
        filename: "[name].css"
      }),
      new HtmlWebpackPlugin({
        template: `ejs-loader!${path.resolve(
          __dirname,
          "../scratchpad/index.html"
        )}`,
        filename: "index.html",
        inject: true
      }),
      new VueLoaderPlugin()
    ]
  };
};
