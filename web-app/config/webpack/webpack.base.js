const { join, resolve } = require("path");
const { realpathSync } = require("fs");
const webpack = require("webpack");
const merge = require("webpack-merge");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const VueLoaderPlugin = require("vue-loader/lib/plugin");
const CaseSensitivePathsPlugin = require("case-sensitive-paths-webpack-plugin");
const PnpWebpackPlugin = require("pnp-webpack-plugin");
const loadEnv = env => args => require(`./webpack.${env}.js`)(args);
const loadPresets = require("./utils/load-presets");

const webpackConfig = (
  { mode, presets } = { mode: "production", presets: [] }
) => {
  const config = require("./config")({ mode, presets });

  return merge(
    {
      mode: mode,
      entry: [
        "application",
        "assets",
        "bootstrap",
        "card-carrousel",
        "contact-us",
        "course-page",
        "course-sharing",
        "courses/show",
        "locales",
        "post-card",
        "providers/show",
        "mailer",
        "search-page",
        "sharing",
        "vcard",
        "vendor",
        "video-preview"
      ].reduce(
        (entries, key) => ({
          ...entries,
          [key.replace(/\/+/g, "-")]: resolve(
            config.sourcePath,
            config.sourceEntryPath,
            key
          )
        }),
        {}
      ),

      output: {
        filename: "js/[name]-[hash].js",
        chunkFilename: "js/[name]-[hash].chunk.js",
        hotUpdateChunkFilename: "js/[id]-[hash].hot-update.js",
        path: config.outputPath,
        publicPath: config.publicPath
      },

      resolve: {
        extensions: config.extensions,
        plugins: [PnpWebpackPlugin]
      },

      resolveLoader: {
        modules: [
          process.env.NODE_PATH ? process.env.NODE_PATH : "node_modules",
          resolve(config.sourcePath),
          ...config.resolvedPaths.map(path => resolve(path))
        ],
        plugins: [PnpWebpackPlugin.moduleLoader(module)]
      },

      module: {
        strictExportPresence: true,
        rules: [
          { parser: { requireEnsure: false } },
          // files
          {
            test: new RegExp(
              `(${config.staticAssetsExtensions.join("|")})$`,
              "i"
            ),
            use: [
              {
                loader: "file-loader",
                options: {
                  name(file) {
                    if (file.includes(config.sourcePath)) {
                      return "media/[path][name]-[hash].[ext]";
                    }
                    return "media/[folder]/[name]-[hash:8].[ext]";
                  },
                  context: join(config.sourcePath)
                }
              }
            ]
          },
          // .svg files are treated differently
          // name wise (I don't know why)
          {
            test: /\.svg$/i,
            use: [
              {
                loader: "file-loader",
                options: {
                  name(file) {
                    if (file.includes(config.sourcePath)) {
                      return "media/[path][name]-[hash].[ext]";
                    }
                    return "media/[folder]/[name]-[hash:8].[ext]";
                  },
                  context: join(config.sourcePath)
                }
              },
              {
                loader: "svgo-loader",
                options: {
                  plugins: [
                    { removeTitle: true },
                    { convertColors: { shorthex: false } },
                    { convertPathData: false },
                    { removeXMLProcInst: true },
                    { removeDesc: true },
                    { removeComments: true },
                    { removeMetadata: true },
                    { removeViewBox: true },
                    { removeDimensions: true },
                    { moveGroupAttrsToElems: true }
                  ]
                }
              }
            ]
          },
          // Process application Javascript code with Babel.
          // Uses application .babelrc to apply any transformations
          {
            test: /\.(js|jsx|mjs|ts|tsx)?(\.erb)?$/,
            include: [config.sourcePath, ...config.resolvedPaths].map(p => {
              try {
                return realpathSync(p);
              } catch (e) {
                return resolve(p);
              }
            }),
            exclude: /node_modules/,
            use: [
              {
                loader: "babel-loader",
                options: {
                  cacheDirectory: true,
                  cacheCompression: process.NODE_ENV === "production",
                  compact: process.NODE_ENV === "production"
                }
              }
            ]
          },
          // Compile standard ES features for JS in node_modules with Babel.
          //   Regex details for exclude: https://regex101.com/r/SKPnnv/1
          {
            test: /\.(js|mjs)$/,
            include: /node_modules/,
            exclude: /(?:@?babel(?:\/|\\{1,2}|-).+)|regenerator-runtime|core-js|^webpack$|^webpack-assets-manifest$|^webpack-cli$|^webpack-sources$|^@rails\/webpacker$/,
            use: [
              {
                loader: "babel-loader",
                options: {
                  babelrc: false,
                  presets: [["@babel/preset-env", { modules: false }]],
                  cacheDirectory: true,
                  cacheCompression: process.NODE_ENV === "production",
                  compact: false,
                  sourceMaps: false
                }
              }
            ]
          },
          // .css files
          {
            test: /\.(css)$/i,
            exclude: [/\.module\.[a-z]+$/, ...config.styledVendors],
            sideEffects: true,
            use: [
              config.extractCSS
                ? config.ssr
                  ? "null-loader"
                  : MiniCssExtractPlugin.loader
                : {
                    loader: "vue-style-loader"
                  },
              {
                loader: "css-loader",
                options: {
                  sourceMap: mode !== "production",
                  importLoaders: 2,
                  modules: false,
                  onlyLocals: config.ssr
                }
              },
              {
                loader: "postcss-loader",
                options: {
                  config: { path: resolve() },
                  sourceMap: mode !== "production"
                }
              }
            ]
          },
          // sass files
          {
            test: /\.(scss|sass)(\.erb)?$/i,
            exclude: [/\.module\.[a-z]+$/, ...config.styledVendors],
            sideEffects: true,
            use: [
              config.extractCSS
                ? config.ssr
                  ? "null-loader"
                  : MiniCssExtractPlugin.loader
                : {
                    loader: "vue-style-loader"
                  },
              {
                loader: "css-loader",
                options: {
                  sourceMap: mode !== "production",
                  importLoaders: 2,
                  modules: false,
                  onlyLocals: config.ssr
                }
              },
              {
                loader: "postcss-loader",
                options: {
                  config: { path: resolve() },
                  sourceMap: mode !== "production"
                }
              },
              {
                loader: "sass-loader",
                options: {
                  sourceMap: mode !== "production",
                  sassOptions: {
                    includePaths: config.resolvedPaths
                  }
                }
              }
            ]
          },
          // module.css files
          {
            test: /\.(css)$/i,
            include: /\.module\.[a-z]+$/,
            sideEffects: false,
            use: [
              config.extractCSS
                ? config.ssr
                  ? "null-loader"
                  : MiniCssExtractPlugin.loader
                : {
                    loader: "vue-style-loader"
                  },
              {
                loader: "css-loader",
                options: {
                  sourceMap: mode !== "production",
                  importLoaders: 2,
                  modules: {
                    localIdentName: "[name]__[local]___[hash:base64:5]",
                    onlyLocals: config.ssr
                  }
                }
              },
              {
                loader: "postcss-loader",
                options: {
                  config: { path: resolve() },
                  sourceMap: mode !== "production"
                }
              }
            ]
          },
          // module.sass files
          {
            test: /\.(scss|sass)$/i,
            include: /\.module\.[a-z]+$/,
            sideEffects: false,
            use: [
              config.extractCSS
                ? config.ssr
                  ? "null-loader"
                  : MiniCssExtractPlugin.loader
                : {
                    loader: "vue-style-loader"
                  },
              {
                loader: "css-loader",
                options: {
                  sourceMap: mode !== "production",
                  importLoaders: 2,
                  modules: {
                    localIdentName: "[name]__[local]___[hash:base64:5]",
                    onlyLocals: config.ssr
                  }
                }
              },
              {
                loader: "postcss-loader",
                options: {
                  config: { path: resolve() },
                  sourceMap: mode !== "production"
                }
              },
              {
                loader: "sass-loader",
                options: { sourceMap: mode !== "production" }
              }
            ]
          },
          // styled vendors
          {
            test: /\.(s?css)$/i,
            include: [...config.styledVendors],
            use: [
              // ignore them
              {
                loader: "null-loader"
              },
              {
                loader: "css-loader",
                options: {
                  sourceMap: mode !== "production",
                  importLoaders: 2,
                  modules: false,
                  onlyLocals: config.ssr
                }
              },
              {
                loader: "postcss-loader",
                options: {
                  config: { path: resolve() },
                  sourceMap: mode !== "production"
                }
              },
              {
                loader: "sass-loader",
                options: {
                  sourceMap: mode !== "production",
                  sassOptions: {
                    includePaths: config.resolvedPaths
                  }
                }
              }
            ]
          },
          // .vue files
          {
            test: /\.vue(\.erb)?$/,
            use: [
              {
                loader: "vue-loader",
                options: {
                  optimizeSSR: false,
                  compilerOptions: {
                    optimizeSSR: false,
                    whitespace: "preserve"
                  }
                }
              }
            ]
          },
          // .yml files
          {
            test: /\.yml$/,
            use: [
              {
                loader: "json-loader"
              },
              {
                loader: "yaml-loader"
              }
            ]
          }
        ]
      },
      plugins: [
        new webpack.EnvironmentPlugin(process.env),
        new CaseSensitivePathsPlugin(),
        new VueLoaderPlugin({
          productionMode: true
        }),
        ...(config.extractCSS && !config.ssr
          ? [
              new MiniCssExtractPlugin({
                filename: "css/[name]-[contenthash:8].css",
                chunkFilename: "css/[name]-[contenthash:8].chunk.css"
              })
            ]
          : [])
      ]
    },
    // development, production
    loadEnv(mode)({ mode, presets }),
    // client, server
    loadPresets(presets)({ mode, presets })
  );
};

if (
  process.env.NODE_ENV === "development" &&
  process.env.WEBPACK_MEASURE === "true"
) {
  const SpeedMeasurePlugin = require("speed-measure-webpack-plugin");
  const smp = new SpeedMeasurePlugin();
  module.exports = smp.wrap(webpackConfig);
} else {
  module.exports = webpackConfig;
}
