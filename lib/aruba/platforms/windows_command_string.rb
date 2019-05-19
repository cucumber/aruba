# Aruba
module Aruba
  # Platforms
  module Platforms
    # This is a command which should be run
    #
    # This adds `cmd.exec` in front of commmand
    #
    # @private
    class WindowsCommandString
      def initialize(command, *arguments)
        @command = command
        @arguments = arguments
      end

      # Convert to array
      def to_a
        [cmd_path, '/c', [escaped_command, *escaped_arguments].join(' ')]
      end

      private

      def escaped_arguments
        @arguments.map { |arg| arg.gsub(/"/, '"""') }.
          map { |arg| arg =~ / / ? "\"#{arg}\"" : arg }
      end

      def escaped_command
        @command.gsub(/ /, '""" """')
      end

      def cmd_path
        Aruba.platform.which('cmd.exe')
      end
    end
  end
end
