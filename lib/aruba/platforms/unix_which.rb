# Aruba
module Aruba
  # Platforms
  module Platforms
    # Implement `which(command)` for UNIX/Linux
    #
    # @private
    class UnixWhich
      # Bail out because this should never be reached
      class DefaultWhich
        def self.match?(*)
          true
        end

        def call(program, path)
          fail %(Invalid input program "#{program}" and/or path "#{path}".)
        end
      end

      # Find path for absolute or relative command
      class AbsoluteOrRelativePathWhich
        def self.match?(program)
          Aruba.platform.absolute_path?(program) || Aruba.platform.relative_command?(program)
        end

        def call(program, path)
          return File.expand_path(program) if Aruba.platform.executable?(program)

          nil
        end
      end

      # Find path for command
      class ProgramWhich
        def self.match?(program)
          Aruba.platform.command?(program)
        end

        # rubocop:disable Metrics/CyclomaticComplexity
        # rubocop:disable Metrics/MethodLength
        def call(program, path)
          # Iterate over each path glob the dir + program.
          path.split(File::PATH_SEPARATOR).each do |dir|
            dir = Aruba.platform.expand_path(dir, Dir.getwd)
            next unless Aruba.platform.exist?(dir) # In case of bogus second argument

            found = Dir[File.join(dir, program)].first
            return found if found && Aruba.platform.executable?(found)
          end

          nil
        end
        # rubocop:enable Metrics/CyclomaticComplexity
        # rubocop:enable Metrics/MethodLength
      end

      private

      attr_reader :whiches

      public

      def initialize
        @whiches = []
        @whiches << AbsoluteOrRelativePathWhich
        @whiches << ProgramWhich
        @whiches << DefaultWhich
      end

      # Find fully quallified path for program
      #
      # @param [String] program
      #   Name of program
      #
      # @param [String] path
      #   ENV['PATH']
      def call(program, path = ENV['PATH'])
        raise ArgumentError, "ENV['PATH'] cannot be empty" if path.nil? || path.empty?
        program = program.to_s

        whiches.find { |w| w.match? program }.new.call(program, path)
      end
    end
  end
end
