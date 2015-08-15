$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'cli/app'

if RUBY_VERSION < '1.9.3'
  ::Dir.glob(::File.expand_path('../support/**/*.rb', __FILE__)).each { |f| require File.join(File.dirname(f), File.basename(f, '.rb')) }
else
  ::Dir.glob(::File.expand_path('../support/**/*.rb', __FILE__)).each { |f| require_relative f }
end
