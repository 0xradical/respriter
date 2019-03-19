const { environment } = require('@rails/webpacker')
const { VueLoaderPlugin } = require('vue-loader')
const MiniCssExtractPlugin = require('mini-css-extract-plugin')
const HtmlWebpackPlugin = require('html-webpack-plugin');

const vue   = require('./loaders/vue')
const yaml  = require('./loaders/yaml')

environment.loaders.append('vue',vue)
environment.loaders.append('yaml',yaml)

environment.plugins.append('MiniCssExtractPlugin', new MiniCssExtractPlugin({ filename: '[name]-[hash].css' }));
environment.plugins.append('VueLoaderPlugin', new VueLoaderPlugin())

module.exports = environment
