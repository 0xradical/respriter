const { resolve } = require("path");
const { ensureTrailingSlash } = require("./utils/helpers");

const config = (env, argv) => {
  // Ensure that the publicPath includes our asset host so dynamic imports
  // (code-splitting chunks and static assets) load from the CDN instead of a relative path.
  const rootUrl = ensureTrailingSlash(process.env.WEBPACK_ASSET_HOST || "/");
  const ssr = [...[env.presets]].includes("server");

  return {
    ssr: ssr,
    sourcePath: process.env.WEBPACK_SOURCE_PATH,
    sourceEntryPath: process.env.WEBPACK_SOURCE_ENTRY_PATH,
    publicOutputPath: process.env.WEBPACK_PUBLIC_OUTPUT_PATH,
    cachePath: process.env.WEBPACK_CACHE_PATH,
    outputPath: resolve("public", process.env.WEBPACK_PUBLIC_OUTPUT_PATH),
    publicPath: `${rootUrl}${process.env.WEBPACK_PUBLIC_OUTPUT_PATH}/`,
    publicPathWithoutCDN: `/${process.env.WEBPACK_PUBLIC_OUTPUT_PATH}/`,

    // Extract and emit CSS files
    extractCSS: true,

    // Additional paths webpack should lookup modules
    // ['app/assets', 'engine/foo/app/assets']
    resolvedPaths: [],

    // do not consider css from these entries
    styledVendors: [/node_modules\/@chenfengyuan\/vue-number-input/],

    // Reload manifest.json on all requests so we reload latest compiled packs
    cacheManifest: false,

    // resolvable extensions
    extensions: [
      ".vue",
      ".yml",
      ".js",
      ".sass",
      ".scss",
      ".css",
      ".module.sass",
      ".module.scss",
      ".module.css",
      ".png",
      ".svg",
      ".gif",
      ".jpeg",
      ".jpg"
    ],
    // file loader
    staticAssetsExtensions: [
      ".jpg",
      ".jpeg",
      ".png",
      ".gif",
      ".tiff",
      ".ico",
      ".eot",
      ".otf",
      ".ttf",
      ".woff",
      ".woff2"
    ]
  };
};

module.exports = config;
