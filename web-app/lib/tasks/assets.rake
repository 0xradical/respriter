# frozen_string_literal: true

namespace :assets do
  desc 'Compile asset bundles using webpack for production with digests into $WEBPACK_PUBLIC_OUTPUT_PATH'
  task precompile: [:environment] do
    # NOOP
    # This is handled by npm run build
  end

  desc 'Assets clean'
  task clean: [:environment] do
    # NOOP
    # This is handled by clean-webpack-plugin
    # See app/config/webpack.base.js
  end
end
