# encoding: utf-8

$LOAD_PATH << ::File.expand_path('../../lib', __FILE__)

require 'simplecov'
SimpleCov.command_name 'rspec'
SimpleCov.start

# Pull in all of the gems including those in the `test` group
require 'bundler'
Bundler.require

# Activate RSpec Integration
require 'aruba/rspec'

# Loading support files
Dir.glob(::File.expand_path('../support/*.rb', __FILE__)).each { |f| require_relative f }
Dir.glob(::File.expand_path('../support/**/*.rb', __FILE__)).each { |f| require_relative f }

# Avoid writing "describe LocalPac::MyClass do [..]" but "describe MyClass do [..]"
include Aruba
