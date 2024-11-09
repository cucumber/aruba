# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'cli/app'

require 'aruba/rspec'

Dir.glob(File.expand_path('support/**/*.rb', __dir__))
   .each { |f| require_relative f }
