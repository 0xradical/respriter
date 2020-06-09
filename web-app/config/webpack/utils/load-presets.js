const webpackMerge = require("webpack-merge");

const loadPresets = presets => args => {
  /** @type {string[]} */
  const mergedPresets = [].concat(...[presets]);
  const mergedConfigs = mergedPresets.map(presetName =>
    require(`../presets/webpack.${presetName}.js`)(args)
  );

  return webpackMerge({}, ...mergedConfigs);
};

module.exports = loadPresets;
