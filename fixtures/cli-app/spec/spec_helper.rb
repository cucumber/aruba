$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'cli/app'

::Dir.glob(::File.expand_path('../support/**/*.rb', __FILE__)).each { |f| require_relative f }
