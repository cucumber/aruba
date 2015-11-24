require 'aruba/processes/basic_process'

module Aruba
  module Processes
    # Null Process
    class NullProcess < BasicProcess
      def self.match?(mode)
        mode == :null
      end

      # Pid
      def pid
        0
      end

      # String representation
      def to_s
        ''
      end
    end
  end
end
