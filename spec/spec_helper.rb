ENV['RACK_ENV'] = 'test'

require 'rubygems'
require 'bundler'
Bundler.require :default, 'test'

require 'json_spec'

require 'simplecov'
SimpleCov.start

require_relative 'support/dummy_model'

I18n.load_path << Dir["#{File.expand_path('spec/support/locales')}/*.yml"]
