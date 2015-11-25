require 'aruba/processes/basic_process'

module Aruba
  module Processes
    # Null Process
    #
    # `NullProcess` is not meant for direct use - `BasicProcess.new` - by users.
    #
    # @private
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
