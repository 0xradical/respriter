const { environment } = require('@rails/webpacker')
const { VueLoaderPlugin } = require('vue-loader')
const MiniCssExtractPlugin = require('mini-css-extract-plugin')
const HtmlWebpackPlugin = require('html-webpack-plugin');
const S3Uploader = require('webpack-s3-uploader')

const vue           = require('./loaders/vue')
const yaml          = require('./loaders/yaml')

environment.loaders.append('vue',vue)
environment.loaders.append('yaml',yaml)

environment.plugins.append('MiniCssExtractPlugin', new MiniCssExtractPlugin({
  filename: process.env.NODE_ENV === 'production' ? '[name]-[hash].css' : '[name].css'
}));

environment.plugins.append('VueLoaderPlugin', new VueLoaderPlugin())

// environment.plugins.append('HtmlWebpackPlugin', new HtmlWebpackPlugin({
  // template: "ejs-loader!./app/assets/html/404.html",
  // showErrors: true,
  // filename: '404.html',
  // inject: true
// }));

// environment.plugins.append('HtmlWebpackPlugin500', new HtmlWebpackPlugin({
  // template: "ejs-loader!./app/frontend/html/500.html",
  // filename: '500.html',
  // inject: false
// }));

if (process.env.NODE_ENV === 'production') {
  environment.plugins.append('S3Uploader', new S3Uploader({
    s3Options: {
      accessKeyId: process.env.AWS_ACCESS_KEY_ID,
      secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
      region: 'us-east-1'
    },
    s3UploadOptions: {
      Bucket: 'quero-cdn/assets'
    }
  }));
}

module.exports = environment
