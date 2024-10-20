# frozen_string_literal: true

require 'aruba/api'

# Aruba
module Aruba
  # Consule
  class Console
    # Helpers for Aruba::Console
    module Help
      # Output help information
      def aruba_help
        puts "Aruba Version: #{Aruba::VERSION}"
        puts 'Issue Tracker: https://github.com/cucumber/aruba/issues'
        puts 'Documentation:'
        puts '* http://www.rubydoc.info/gems/aruba'
        puts

        nil
      end

      # List available methods in aruba
      def aruba_methods
        ms = (Aruba::Api.instance_methods - Module.instance_methods)
             .each_with_object([]) { |e, a| a << format('* %s', e) }
             .sort

        puts "Available Methods:\n#{ms.join("\n")}"

        nil
      end
    end
  end
end
