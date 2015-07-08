require 'aruba/process_monitor'
require 'aruba/spawn_process'
require 'pathname'

require 'win32/file' if File::ALT_SEPARATOR

module Aruba
  class << self
    attr_accessor :process
  end

  self.process = Aruba::Processes::SpawnProcess
end

module Aruba
  module Api
    module Commands
      # Resolve path for command using the PATH-environment variable
      #
      # Mostly taken from here: https://github.com/djberg96/ptools
      #
      # @param [#to_s] program
      #   The name of the program which should be resolved
      #
      # @param [String] path
      #   The PATH, a string concatenated with ":", e.g. /usr/bin/:/bin on a
      #   UNIX-system
      #
      # rubocop:disable Metrics/MethodLength
      # rubocop:disable Metrics/CyclomaticComplexity
      def which(program, path = ENV['PATH'])
        on_windows = false
        on_windows = true if File::ALT_SEPARATOR

        program = program.to_s

        path_exts = ENV['PATHEXT'] ? ('.{' + ENV['PATHEXT'].tr(';', ',').tr('.','') + '}').downcase : '.{exe,com,bat}' if on_windows

        raise ArgumentError, "ENV['PATH'] cannot be empty" if path.nil? || path.empty?

        # Bail out early if an absolute path is provided.
        if Aruba::Platform.absolute_path? program
          program += path_exts if on_windows && File.extname(program).empty?

          found = Dir[program].first

          return found if found && Aruba::Platform.executable_file?(found)
          return nil
        end

        # Iterate over each path glob the dir + program.
        path.split(File::PATH_SEPARATOR).each do |dir|
          dir = Aruba::Platform.expand_path(dir, Dir.getwd)

          next unless Aruba::Platform.exist?(dir) # In case of bogus second argument
          file = File.join(dir, program)

          # Dir[] doesn't handle backslashes properly, so convert them. Also, if
          # the program name doesn't have an extension, try them all.
          if on_windows
            file = file.tr("\\", "/")
            file += path_exts if File.extname(program).empty?
          end

          found = Dir[file].first

          # Convert all forward slashes to backslashes if supported
          if found && Aruba::Platform.executable_file?(found)
            found.tr!(File::SEPARATOR, File::ALT_SEPARATOR) if on_windows
            return found
          end
        end

        nil
      end
      # rubocop:enable Metrics/MethodLength
      # rubocop:enable Metrics/CyclomaticComplexity
    end
  end
end
