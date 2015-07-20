require 'aruba/environments/basic_environment'

module Aruba
  module Environments
    class WindowsEnvironment < BasicEnvironment
      def match?(*)
        Aruba::Platform.windows?
      end

      def initialize
        if RUBY_VERSION < '1.9.3'
          # rubocop:disable Style/EachWithObject
          @env = ENV.to_hash.inject({}) { |a, (k, v)| a[k.to_s.upcase] = v; a }
          #rubocop:enable Style/EachWithObject
        else
          @env = ENV.to_hash.each_with_object({}) { |(k, v), a| a[k.to_s.upcase] = v }
        end
      end
    end
  end
end
