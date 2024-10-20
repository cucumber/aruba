# frozen_string_literal: true

require 'thor/group'
require 'thor/actions'

# Aruba
module Aruba
  # Initializers
  #
  # Initialize project with aruba configuration files
  module Initializers
    #
    # Common initializer
    #
    # @private
    class CommonInitializer < Thor::Group
      include Thor::Actions

      # Add gem to gemfile
      def add_gem
        file = 'Gemfile'
        creator = if File.exist? file
                    :append_to_file
                  else
                    :create_file
                  end

        content = if File.exist? file
                    file_ends_with_carriage_return =
                      File.open(file, 'r').readlines.last.match(/.*\n$/)

                    prefix = file_ends_with_carriage_return ? '' : "\n"

                    %(#{prefix}gem 'aruba', '~> #{Aruba::VERSION}')
                  else
                    %(source 'https://rubygems.org'\ngem 'aruba', '~> #{Aruba::VERSION}'\n)
                  end
        send creator, file, content
      end
    end

    #
    # Failing Initializer
    #
    # This handles invalid values for initializer.
    #
    # @private
    class FailingInitializer
      class << self
        def match?(*)
          true
        end

        def start(*)
          raise ArgumentError,
                %(Unknown test framework. Please use one of :rspec, :cucumber or :minitest)
        end
      end
    end

    # RSpec Initializer. Adds aruba + rspec to project
    #
    # @private
    class RSpecInitializer < Thor::Group
      include Thor::Actions

      no_commands do
        def self.match?(framework)
          framework.downcase.to_sym == :rspec
        end
      end

      def create_helper
        file = 'spec/spec_helper.rb'
        creator = if File.exist? file
                    :append_to_file
                  else
                    :create_file
                  end

        send creator, file, <<~EOS
          $LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

          ::Dir.glob(::File.expand_path('../support/*.rb', __FILE__)).each { |f| require_relative f }
          ::Dir.glob(::File.expand_path('../support/**/*.rb', __FILE__)).each { |f| require_relative f }
        EOS
      end

      def create_support_file
        create_file 'spec/support/aruba.rb', <<~EOS
          require 'aruba/rspec'
        EOS
      end
    end

    #
    # Cucumber Initializer. Adds Aruba + Cucumber to project
    #
    # @private
    class CucumberInitializer < Thor::Group
      include Thor::Actions

      no_commands do
        def self.match?(framework)
          framework.downcase.to_sym == :cucumber
        end
      end

      def create_support_file
        create_file 'features/support/aruba.rb', <<~EOS
          require 'aruba/cucumber'
        EOS
      end
    end

    #
    # Minitest Initializer. Adds Aruba + Minitest to project
    #
    # @private
    class MiniTestInitializer < Thor::Group
      include Thor::Actions

      no_commands do
        def self.match?(framework)
          framework.downcase.to_sym == :minitest
        end
      end

      def create_helper
        file =  'test/test_helper.rb'
        creator = if File.exist? file
                    :append_to_file
                  else
                    :create_file
                  end

        send creator, file, <<~EOS
          $LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

          ::Dir.glob(::File.expand_path('../support/*.rb', __FILE__)).each { |f| require_relative f }
          ::Dir.glob(::File.expand_path('../support/**/*.rb', __FILE__)).each { |f| require_relative f }
        EOS
      end

      def create_example
        create_file 'test/use_aruba_with_minitest.rb', <<~EOS
          $LOAD_PATH.unshift File.expand_path('../test', __FILE__)

          require 'test_helper'
          require 'minitest/autorun'
          require 'aruba/api'

          class FirstRun < Minitest::Test
            include Aruba::Api

            def setup
              setup_aruba
            end

            def test_dummy
              skip "Add some real tests here"
            end
          end
        EOS
      end
    end
  end

  # The whole initializer
  #
  # This one uses the specific initializers to generate the needed files.
  #
  # @private
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

    # Create files etc.
    def call(test_framework)
      begin
        initializers.find { |i| i.match? test_framework }.start [], {}
      rescue ArgumentError => e
        warn e.message
        exit 0
      end

      Initializers::CommonInitializer.start [], {}
    end
  end
end
