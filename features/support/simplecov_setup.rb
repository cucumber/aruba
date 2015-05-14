# @note this file is loaded in env.rb to setup simplecov using RUBYOPTs for child processes and @in-process
require 'simplecov'

root = File.expand_path('../../../', __FILE__)

SimpleCov.command_name(ENV['SIMPLECOV_COMMAND_NAME'])
SimpleCov.root(root)
load File.join(root, '.simplecov')
