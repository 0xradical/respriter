const { dev_server: devServer } = require('@rails/webpacker').config
const isProduction = process.env.NODE_ENV === 'production'
const inDevServer = process.argv.find(v => v.includes('webpack-dev-server'))

module.exports = {
  test: /\.svg$/,
  use:[
    {
      loader: 'file-loader',
      options: {
        name: '[name]-[hash].[ext]'
      }
    },
    {
      loader: 'svgo-loader',
      options: {
        plugins: [
          { removeTitle: true},
          { convertColors: { shorthex: false  } },
          { convertPathData: false },
          { removeXMLProcInst: true },
          { removeDesc: true },
          { removeComments: true },
          { removeMetadata: true },
          { removeViewBox: true },
          { removeDimensions: true },
          { moveGroupAttrsToElems: true} 
        ]
      }
    }
  ]
}
