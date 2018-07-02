const path = require('path');
const VueLoaderPlugin = require('vue-loader/lib/plugin')

module.exports = {
  // $ webpack --mode production
  mode: process.env.WEBPACK_MODE || 'production',
  entry: {
    index: './client/index.mjs',
  },
  output: {
    filename: '[name].js',
    path: path.join(__dirname, 'public')
  },
  plugins: [
    new VueLoaderPlugin()
  ],
  resolve: {
    extensions: ['.mjs', '.js'],
    alias: {
      'vue$': 'vue/dist/vue.esm.js'
    }
  },
  module: {
    rules: [
      {
        test: /\.vue$/,
        loader: 'vue-loader',
        options: {
          loaders: {
            'scss': 'vue-style-loader!css-loader!sass-loader'
          }
        }
      },
      {
        test: /\.scss$/,
        use: [
          'vue-style-loader',
          'css-loader',
          'sass-loader'
        ]
      }
    ]
  }
}
