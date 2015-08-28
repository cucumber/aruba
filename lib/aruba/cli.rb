require 'thor'
require 'aruba/console'
require 'aruba/initializer'

module Aruba
  class Cli < Thor
    def self.exit_on_failure?
      true
    end

    desc 'console', "Start aruba's console"
    def console
      Aruba::Console.new.start
    end

    desc 'init', 'Initialize aruba'
    option :test_framework, :default => 'cucumber', :enum => %w(cucumber rspec minitest), :desc => 'Choose which test framework to use'
    def init
      Aruba::Initializer.new.call(options[:test_framework])
    end
  end
end
