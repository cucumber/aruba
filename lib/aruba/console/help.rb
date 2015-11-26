require 'aruba/api'

# Aruba
module Aruba
  # Consule
  class Console
    # Helpers for Aruba::Console
    module Help
      # Output help information
      def aruba_help
        puts 'Aruba Version: ' + Aruba::VERSION
        puts 'Issue Tracker: ' + 'https://github.com/cucumber/aruba/issues'
        puts "Documentation:\n" + %w(http://www.rubydoc.info/gems/aruba).map { |d| format('* %s', d) }.join("\n")
        puts

        nil
      end

      # List available methods in aruba
      def aruba_methods
        ms = if RUBY_VERSION < '1.9'
               # rubocop:disable Style/EachWithObject
               (Aruba::Api.instance_methods - Module.instance_methods).inject([]) { |a, e| a << format("* %s", e); a }.sort
               # rubocop:enable Style/EachWithObject
             else
               (Aruba::Api.instance_methods - Module.instance_methods).each_with_object([]) { |e, a| a << format("* %s", e) }.sort
             end

        puts "Available Methods:\n" + ms.join("\n")

        nil
      end
    end
  end
end
