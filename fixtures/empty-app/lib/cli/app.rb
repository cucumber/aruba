require 'cli/app/version'

if RUBY_VERSION < '1.9.3'
  ::Dir.glob(::File.expand_path('../**/*.rb', __FILE__)).each { |f| require File.join(File.dirname(f), File.basename(f, '.rb')) }
else
  ::Dir.glob(File.expand_path('../**/*.rb', __FILE__)).each { |f| require_relative f }
end

module Cli
  module App
    # Your code goes here...
  end
end
