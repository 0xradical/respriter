const path = require('path');
const VueLoaderPlugin = require('vue-loader/lib/plugin');

module.exports = {
  target: 'node',
  entry: path.join(__dirname, 'app/assets/js/ssr/server.js'),
  output: {
    path: path.join(__dirname, '/ssr'),
    filename: 'ssr.js',
    libraryTarget: 'commonjs2'
  },
  externals: {
		canvas: "commonjs canvas"
	},
  module: {
    rules: [
      {
        test: /\.js$/,
        include: [
          path.join(__dirname, 'app/assets'),
        ],
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
        test: /\.scss$/,
        use: [
          'vue-style-loader',
          'css-loader',
          'sass-loader'
        ]
      },
      {
        test: /\.yml$/,
        use: [
          'json-loader',
          'yaml-loader'
        ]
      },
    ]
  },
  plugins: [
    new VueLoaderPlugin()
  ]
}