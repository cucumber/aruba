require 'rspec/expectations'
require 'aruba/announcer'
require 'aruba/runtime'
require 'aruba/errors'

require 'aruba/config/jruby'

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
        Aruba::Platform.rm File.join(Aruba.config.root_directory, Aruba.config.working_directory), :force => true
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
      # rubocop:disable Metrics/MethodLength
      def cd(dir, &block)
        if block_given?
          begin
            fail ArgumentError, "#{expand_path(dir)} is not a directory or does not exist." unless Aruba::Platform.directory? expand_path(dir)

            aruba.current_directory << dir

            old_dir    = Aruba::Platform.getwd
            old_oldpwd = ENV['OLDPWD']
            old_pwd    = ENV['PWD']

            ENV['OLDPWD'] = Aruba::Platform.getwd
            ENV['PWD'] = File.join(aruba.root_directory, aruba.current_directory).sub(%r{/$}, '')

            Aruba::Platform.chdir File.join(aruba.root_directory, aruba.current_directory)

            result = block.call
          ensure
            aruba.current_directory.pop
            Aruba::Platform.chdir old_dir
            ENV['OLDPWD'] = old_oldpwd
            ENV['PWD']    = old_pwd
          end

          return result
        end

        fail ArgumentError, "#{expand_path(dir)} is not a directory or does not exist." unless Aruba::Platform.directory? expand_path(dir)

        aruba.current_directory << dir

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
        # rubocop:disable Metrics/LineLength
        message = %(Filename "#{file_name}" needs to be a string. It cannot be nil or empty either.  Please use `expand_path('.')` if you want the current directory to be expanded.)
        # rubocop:enable Metrics/LineLength

        fail ArgumentError, message unless file_name.is_a?(String) && !file_name.empty?

        if RUBY_VERSION < '1.9'
          prefix = file_name.chars.to_a[0]
          rest = file_name.chars.to_a[1..-1].join('')
        else
          prefix = file_name[0]
          rest = file_name[1..-1]
        end

        if aruba.config.fixtures_path_prefix == prefix
          File.join aruba.fixtures_directory, rest
        elsif '~' == prefix
          path = with_environment do
            ArubaPath.new(File.expand_path(file_name))
          end

          fail 'Expanding "~/" to "/" is not allowed' if path.to_s == '/'
          fail %(Expanding "~/" to a relative path "#{path}" is not allowed) unless path.absolute?

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
        if RUBY_VERSION <= '1.9.3'
          old_env = ENV.to_hash
        else
          old_env = ENV.to_h
        end

        old_aruba_env = aruba.environment.to_h

        ENV.update aruba.environment.update(env).to_h

        block.call if block_given?
      ensure
        aruba.environment.clear
        aruba.environment.update old_aruba_env

        ENV.clear
        ENV.update old_env
      end
    end
  end
end
