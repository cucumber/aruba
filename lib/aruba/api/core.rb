require 'rspec/expectations'
require 'aruba/announcer'
require 'aruba/runtime'
require 'aruba/errors'

require 'aruba/config/jruby'
require 'aruba/aruba_logger'

module Aruba
  module Api
    # Core methods of aruba
    #
    # Those methods do not depend on any other API method of aruba
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
        Aruba.platform.rm File.join(Aruba.config.root_directory, Aruba.config.working_directory), :force => true
        Aruba.platform.mkdir File.join(Aruba.config.root_directory, Aruba.config.working_directory)
        Aruba.platform.chdir Aruba.config.root_directory

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
      # rubocop:disable Metrics/MethodLength
      def cd(dir, &block)
        if block_given?
          begin
            fail ArgumentError, "#{expand_path(dir)} is not a directory or does not exist." unless Aruba.platform.directory? expand_path(dir)

            aruba.current_directory << dir
            announcer.announce :directory, expand_path(dir)

            old_dir    = Aruba.platform.getwd

            Aruba.platform.chdir File.join(aruba.root_directory, aruba.current_directory)

            result = Aruba.platform.with_environment(
              'OLDPWD' => old_dir,
              'PWD' => File.join(aruba.root_directory, aruba.current_directory).sub(%r{/$}, ''),
              &block
            )
          ensure
            aruba.current_directory.pop
            Aruba.platform.chdir old_dir
          end

          return result
        end

        fail ArgumentError, "#{expand_path(dir)} is not a directory or does not exist." unless Aruba.platform.directory? expand_path(dir)

        aruba.current_directory << dir
        announcer.announce :directory, expand_path(dir)

        self
      end
      # rubocop:enable Metrics/MethodLength

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
      # rubocop:disable Metrics/MethodLength
      # rubocop:disable Metrics/CyclomaticComplexity
      def expand_path(file_name, dir_string = nil)
        check_for_deprecated_variables if Aruba::VERSION < '1'

        # rubocop:disable Metrics/LineLength
        message = %(Filename "#{file_name}" needs to be a string. It cannot be nil or empty either.  Please use `expand_path('.')` if you want the current directory to be expanded.)
        # rubocop:enable Metrics/LineLength

        fail ArgumentError, message unless file_name.is_a?(String) && !file_name.empty?

        # rubocop:disable Metrics/LineLength
        aruba.logger.warn %(`aruba`'s working directory does not exist. Maybe you forgot to run `setup_aruba` before using it's API. This warning will be an error from 1.0.0) unless Aruba.platform.directory? File.join(aruba.config.root_directory, aruba.config.working_directory)
        # rubocop:enable Metrics/LineLength

        if RUBY_VERSION < '1.9'
          prefix = file_name.chars.to_a[0].to_s
          rest = if file_name.chars.to_a[2..-1].nil?
                   nil
                 else
                   file_name.chars.to_a[2..-1].join
                 end
        else
          prefix = file_name[0]
          rest = file_name[2..-1]
        end

        if aruba.config.fixtures_path_prefix == prefix
          path = File.join(*[aruba.fixtures_directory, rest].compact)

          # rubocop:disable Metrics/LineLength
          fail ArgumentError, %(Fixture "#{rest}" does not exist in fixtures directory "#{aruba.fixtures_directory}". This was the one we found first on your system from all possible candidates: #{aruba.config.fixtures_directories.map { |p| format('"%s"', p) }.join(', ')}.) unless Aruba.platform.exist? path
          # rubocop:enable Metrics/LineLength

          path
        elsif '~' == prefix
          path = with_environment do
            ArubaPath.new(File.expand_path(file_name))
          end

          fail ArgumentError, 'Expanding "~/" to "/" is not allowed' if path.to_s == '/'
          fail ArgumentError, %(Expanding "~/" to a relative path "#{path}" is not allowed) unless path.absolute?

          path.to_s
        else
          directory = File.join(aruba.root_directory, aruba.current_directory)
          ArubaPath.new(File.join(*[directory, dir_string, file_name].compact)).expand_path.to_s
        end
      end
      # rubocop:enable Metrics/MethodLength
      # rubocop:enable  Metrics/CyclomaticComplexity

      # Run block with environment
      #
      # @param [Hash] env (optional)
      #   The variables to be used for block.
      #
      # @yield
      #   The block of code which should be run with the modified environment variables
      def with_environment(env = {}, &block)
        old_aruba_env = aruba.environment.to_h

        Aruba.platform.with_environment aruba.environment.update(env).to_h, &block
      ensure
        aruba.environment.clear
        aruba.environment.update old_aruba_env
      end
    end
  end
end
