require 'cli/app/version'

::Dir.glob(File.expand_path('**/*.rb', __dir__)).each { |f| require_relative f }

module Cli
  module App
    # Your code goes here...
  end
end
