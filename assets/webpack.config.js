const path = require('path');
const webpack = require('webpack');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');

const mixEnv = process.env.MIX_ENV || 'dev';
const isProduction = mixEnv === 'prod';
const mode = process.env.NODE_ENV || 'development';

const staticDir = path.join(__dirname, '.');

module.exports = (env, options) => ({
  optimization: {
    minimizer: [
      new OptimizeCSSAssetsPlugin({})
    ]
  },
  mode,
  entry: [`${staticDir}/js/app.js`, `${staticDir}/css/app.scss`],
  output: {
    filename: 'app.js',
    path: path.resolve(__dirname, '../priv/static/js')
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader'
        }
      },
      {
        test: /\.(sass|scss)$/,
        use: [
          // production doesn't need HMR, so should extract css as file
          // MiniCssExtractPlugin is used for that
          // style-loader is used for HMR support in dev
          { loader: mode === 'production' ? MiniCssExtractPlugin.loader : 'style-loader' },
          { loader: 'css-loader', options: { sourceMap: true } },
          { loader: 'sass-loader', options: { sourceMap: true, includePaths: [] }, },
        ],
      },
    ]
  },
  plugins: [
    new MiniCssExtractPlugin({ filename: 'css/app.css' }),
    new CopyWebpackPlugin([{ from: 'static/', to: '../' }]),
    new webpack.NamedModulesPlugin(),
    new webpack.HotModuleReplacementPlugin(),
  ]
});
