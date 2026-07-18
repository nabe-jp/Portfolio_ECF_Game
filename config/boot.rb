ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require "logger" # Rails 6.1 + Ruby 3.1環境でActiveSupport読み込み時のLogger未定義エラーを回避するため

require "bundler/setup" # Set up gems listed in the Gemfile.
require "bootsnap/setup" # Speed up boot time by caching expensive operations.