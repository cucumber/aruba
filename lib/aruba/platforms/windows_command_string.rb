require 'delegate'

module Aruba
  module Platforms
    # This is a command which should be run
    class WindowsCommandString < SimpleDelegator
      def initialize(cmd)
        __setobj__ 'cmd.exe /c ' + cmd
      end

      if RUBY_VERSION < '1.9'
        def to_s
          __getobj__.to_s
        end
        alias_method :inspect, :to_s
      end
    end
  end
end
