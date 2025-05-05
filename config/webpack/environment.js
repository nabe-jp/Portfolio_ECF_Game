const { environment } = require('@rails/webpacker')

module.exports = environment

// カリュキュラムより抜粋、popper.jsは@popperjs/coreに置き換わっているかも、Bootstrap 5以降では書き換えが必要かも
const webpack = require('webpack')
environment.plugins.prepend(
  'Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery',
    Popper: 'popper.js'
  })
)