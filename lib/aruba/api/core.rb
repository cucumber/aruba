require 'rspec/expectations'
require 'aruba/announcer'
require 'aruba/runtime'
require 'aruba/jruby'
require 'aruba/errors'

module Aruba
  module Api
    module Core
      include ::RSpec::Matchers

      # Aruba Runtime
      def aruba
        @_aruba_runtime ||= Runtime.new
      end

      # Clean the working directory of aruba
      #
      # This will only clean up aruba's working directory to remove all
      # artifacts of your tests. This does NOT clean up the current working
      # directory.
      def setup_aruba
        Aruba::Platform.rm File.join(Aruba.config.root_directory, Aruba.config.working_directory), force: true
        Aruba::Platform.mkdir File.join(Aruba.config.root_directory, Aruba.config.working_directory)
        Aruba::Platform.chdir Aruba.config.root_directory

        self
      end

      # Switch to directory
      #
      # @param [String] dir
      #   The directory
      #
      # @example Normal directory
      #   cd 'dir'
      #
      # @example Move up
      #   cd '..'
      #
      # @example Run code in directory
      #   result = cd('some-dir') { Dir.getwd }
      #
      def cd(dir, &block)
        fail ArgumentError, "#{expand_path(dir)} is not a directory or does not exist." unless directory?(dir)

        if block_given?
          cwd = (aruba.current_directory.dup << dir)
          return Aruba::Platform.chdir(cwd, &block)
        end

        aruba.current_directory << dir

        self
      end

      # Expand file name
      #
      # @param [String] file_name
      #   Name of file
      #
      # @param [String] dir_string
      #   Name of directory to use as starting point, otherwise current directory is used.
      #
      # @return [String]
      #   The full path
      #
      # @example Single file name
      #
      #   # => <path>/tmp/aruba/file
      #   expand_path('file')
      #
      # @example Single Dot
      #
      #   # => <path>/tmp/aruba
      #   expand_path('.')
      #
      # @example using home directory
      #
      #   # => <path>/home/<name>/file
      #   expand_path('~/file')
      #
      # @example using fixtures directory
      #
      #   # => <path>/test/fixtures/file
      #   expand_path('%/file')
      #
      def expand_path(file_name, dir_string = nil)
        message = "Filename cannot be nil or empty. Please use `expand_path('.')` if you want the current directory to be expanded."

        # rubocop:disable Style/RaiseArgs
        fail ArgumentError, message if file_name.nil? || file_name.empty?
        # rubocop:enable Style/RaiseArgs

        if aruba.config.fixtures_path_prefix == file_name[0]
          File.join fixtures_directory, file_name[1..-1]
        else
          Aruba::Platform.chdir(aruba.current_directory) { File.expand_path(file_name, dir_string) }
        end
      end
    end
  end
end
