require 'thor/group'
require 'thor/actions'

module Aruba
  module Initializers
    class CommonInitializer < Thor::Group
      include Thor::Actions

      def add_gem
        file = 'Gemfile'
        creator = if File.exist? file
                    :append_to_file
                  else
                    :create_file
                  end

        content = if File.exist? file
                    %(gem 'aruba', '~> #{Aruba::VERSION}')
                  else
                    %(source 'https://rubygems.org'\ngem 'aruba', '~> #{Aruba::VERSION}'\n)
                  end
        send creator, file, content
      end
    end
  end
end

module Aruba
  module Initializers
    class FailingInitializer
      class << self
        def match?(*)
          true
        end

        def start(*)
          fail ArgumentError, %(Unknown test framework. Please use one of :rspec, :cucumber or :minitest)
        end
      end
    end
  end
end

module Aruba
  module Initializers
    class RSpecInitializer < Thor::Group
      include Thor::Actions

      no_commands do
        def self.match?(framework)
          :rspec == framework.downcase.to_sym
        end
      end

      def create_helper
        file = 'spec/spec_helper.rb'
        creator = if File.exist? file
                    :append_to_file
                  else
                    :create_file
                  end

        send creator, file, <<-EOS
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

if RUBY_VERSION < '1.9.3'
  ::Dir.glob(::File.expand_path('../support/*.rb', __FILE__)).each { |f| require File.join(File.dirname(f), File.basename(f, '.rb')) }
  ::Dir.glob(::File.expand_path('../support/**/*.rb', __FILE__)).each { |f| require File.join(File.dirname(f), File.basename(f, '.rb')) }
else
  ::Dir.glob(::File.expand_path('../support/*.rb', __FILE__)).each { |f| require_relative f }
  ::Dir.glob(::File.expand_path('../support/**/*.rb', __FILE__)).each { |f| require_relative f }
end
EOS
      end

      def create_support_file
        create_file 'spec/support/aruba.rb', <<-EOS
require 'aruba/rspec'
EOS
      end
    end
  end
end

module Aruba
  module Initializers
    class CucumberInitializer < Thor::Group
      include Thor::Actions

      no_commands do
        def self.match?(framework)
          :cucumber == framework.downcase.to_sym
        end
      end

      def create_support_file
        create_file 'features/support/aruba.rb', <<-EOS
require 'aruba/cucumber'
EOS
      end
    end
  end
end

module Aruba
  module Initializers
    class MiniTestInitializer < Thor::Group
      include Thor::Actions

      no_commands do
        def self.match?(framework)
          :minitest == framework.downcase.to_sym
        end
      end

      def create_helper
        file =  'test/test_helper.rb'
        creator = if File.exist? file
                    :append_to_file
                  else
                    :create_file
                  end

        send creator, file, <<-EOS
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

if RUBY_VERSION < '1.9.3'
  ::Dir.glob(::File.expand_path('../support/*.rb', __FILE__)).each { |f| require File.join(File.dirname(f), File.basename(f, '.rb')) }
  ::Dir.glob(::File.expand_path('../support/**/*.rb', __FILE__)).each { |f| require File.join(File.dirname(f), File.basename(f, '.rb')) }
else
  ::Dir.glob(::File.expand_path('../support/*.rb', __FILE__)).each { |f| require_relative f }
  ::Dir.glob(::File.expand_path('../support/**/*.rb', __FILE__)).each { |f| require_relative f }
end
EOS
      end

      def create_example
        create_file 'test/use_aruba_with_minitest.rb', <<-EOS
$LOAD_PATH.unshift File.expand_path('../test', __FILE__)

require 'test_helper'
require 'minitest/autorun'
require 'aruba/api'

class FirstRun < Minitest::Test
  include Aruba::Api

  def setup
    aruba_setup
  end
end
EOS
      end
    end
  end
end

module Aruba
  class Initializer
    private

    attr_reader :initializers

    public

    def initialize
      @initializers = []
      @initializers << Initializers::RSpecInitializer
      @initializers << Initializers::CucumberInitializer
      @initializers << Initializers::MiniTestInitializer
      @initializers << Initializers::FailingInitializer
    end

    def call(test_framework)
      begin
        initializers.find { |i| i.match? test_framework }.start [], {}
      rescue ArgumentError => e
        $stderr.puts e.message
        exit 0
      end

      Initializers::CommonInitializer.start [], {}
    end
  end
end
