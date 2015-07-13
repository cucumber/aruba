module Aruba
  module Api
    module Deprecated
      # @deprecated
      # The path to the directory which should contain all your test data
      # You might want to overwrite this method to place your data else where.
      #
      # @return [Array]
      #   The directory path: Each subdirectory is a member of an array
      def dirs
        Aruba::Platform.deprecated('The use of "@dirs" is deprecated. Use "Aruba.configure { |c| c.current_directory = \'path/to/dir\' }" instead to set the "current_directory') if defined? @dirs
        Aruba::Platform.deprecated('The use of "dirs" deprecated. Use "Aruba.configure { |c| c.current_directory = \'path/to/dir\' }" instead to set the "current_directory and "expand_path(".")" to get the current directory or use "#cd(\'.\') { # your code }" to run code in the current directory')

        @dirs ||= aruba.current_directory
      end

      # @deprecated
      # Get access to current dir
      #
      # @return
      #   Current directory
      def current_directory
        Aruba::Platform.deprecated(%(The use of "current_directory" deprecated. Use "expand_path(".")" to get the current directory or "#cd" to run code in the current directory. #{caller.first}))

        aruba.current_directory.to_s
      end

      # @deprecated
      # Clean the current directory
      def clean_current_directory
        Aruba::Platform.deprecated('The use of "clean_current_directory" is deprecated. Either use "#setup_aruba" or `#remove(\'.\') to clean up aruba\'s working directory before your tests are run')

        setup_aruba
      end

      # @deprecated
      # Execute block in current directory
      #
      # @yield
      #   The block which should be run in current directory
      def in_current_directory(&block)
        Aruba::Platform.deprecated('The use of "in_current_directory" deprecated. Use "#cd(\'.\') { # your code }" instead. But be aware, `cd` requires a previously created directory')

        create_directory '.' unless directory?('.')
        cd('.', &block)
      end

      # @deprecated
      def detect_ruby(cmd)
        Aruba::Platform.deprecated('The use of "#detect_ruby" is deprecated. Use "Aruba::Platform.detect_ruby" instead')

        Aruba::Platform.detect_ruby cmd
      end

      # @deprecated
      def current_ruby
        Aruba::Platform.deprecated('The use of "#current_ruby" is deprecated. Use "Aruba::Platform.current_ruby" instead')

        Aruba::Platform.current_ruby cmd
      end

      # @deprecated
      def _ensure_newline(str)
        Aruba::Platform.deprecated('The use of "#_ensure_newline" is deprecated. Use "Aruba::Platform.ensure_newline" instead')

        Aruba::Platform.ensure_newline cmd
      end

      # @deprecated
      def absolute_path(*args)
        Aruba::Platform.deprecated('The use of "absolute_path" is deprecated. Use "expand_path" instead. But be aware that "expand_path" uses a different implementation')

        File.expand_path File.join(*args), aruba.current_directory
      end

      # @deprecated
      def _read_interactive
        Aruba::Platform.deprecated('The use of "#_read_interactive" is deprecated. Please use "last_command.stdout" instead')

        last_command.stdout
      end

      # @deprecated
      def announce_or_puts(msg)
        Aruba::Platform.deprecated('The use of "#announce_or_puts" is deprecated. Please use "#announcer.mode = :kernel" or "#announcer.mode = :puts" instead')

        if(@puts)
          Kernel.puts(msg)
        else
          puts(msg)
        end
      end

      # @deprecated
      def _write_interactive(input)
        Aruba::Platform.deprecated('The use of "#_write_interactive" is deprecated. Please use "#last_command.write()" instead')

        last_command.write(input)
      end

      # @deprecated
      def eot
        Aruba::Platform.deprecated(%{\e[35m    The \"#eot\"-method is deprecated. It will be deleted with the next major version. Please use \"#close_input\"-method instead.\e[0m})

        close_input
      end

      # Run a command interactively
      #
      # @param [String] cmd
      #   The command to by run
      #
      # @see #cmd
      # @deprectated
      def run_interactive(cmd)
        Aruba::Platform.deprecated('The use of "#run_interactive" is deprecated. You can simply use "run" instead')

        run(cmd)
      end

      # @deprecated
      # Create an empty file
      #
      # @param [String] file_name
      #   The name of the file
      def touch_file(*args)
        Aruba::Platform.deprecated('The use of "#touch_file" is deprecated. Use "#touch" instead')

        touch(*args)
      end

      # @deprecated
      def mod?(file, perms, &block)
        Aruba::Platform.deprecated('The use of "#mod?" is deprecated. Use "expect().to have_permissions()" instead')

        expect(Array(file)).to all have_permissions(perms)
      end

      # @deprecated
      # Remove file
      #
      # @param [String] file_name
      #    The file which should be deleted in current directory
      def remove_file(*args)
        Aruba::Platform.deprecated('The use of "#remove_file" is deprecated. Use "#remove" instead')

        remove(*args)
      end

      # @deprecated
      def create_dir(*args)
        Aruba::Platform.deprecated('The use of "#create_dir" is deprecated. Use "#create_directory" instead')
        create_directory(*args)
      end

      # @deprecated
      # Remove directory
      #
      # @param [String] directory_name
      #   The name of the directory which should be removed
      def remove_directory(*args)
        Aruba::Platform.deprecated('The use of "remove_directory" is deprecated. Use "remove" instead')
        remove(*args)
      end

      # @deprecated
      def remove_dir(*args)
        Aruba::Platform.deprecated('The use of "remove_dir" is deprecated. Use "remove" instead')
        remove(*args)
      end

      # @deprecated
      #
      # Check if paths are present
      #
      # @param [#each] paths
      #   The paths which should be checked
      #
      # @param [true,false] expect_presence
      #   Should the given paths be present (true) or absent (false)
      def check_file_presence(paths, expect_presence = true)
        Aruba::Platform.deprecated('The use of "check_file_presence" is deprecated. Use "expect().to be_existing_file or expect(all_paths).to match_path_pattern() instead" ')

        stop_processes!

        Array(paths).each do |path|
          if path.kind_of? Regexp
            if expect_presence
              expect(all_paths).to match_path_pattern(path)
            else
              expect(all_paths).not_to match_path_pattern(path)
            end
          else
            if expect_presence
              expect(path).to be_an_existing_file
            else
              expect(path).not_to be_an_existing_file
            end
          end
        end
      end

      # @deprecated
      # Check the file size of paths
      #
      # @params [Hash] paths_and_sizes
      #   A hash containing the path (key) and the expected size (value)
      #
      # @example
      #
      #   paths_and_sizes = {
      #     'file' => 10
      #   }
      #
      #   check_file_size(paths_and_sizes)
      #
      def check_file_size(paths_and_sizes)
        Aruba::Platform.deprecated('The use of "#check_file_size" is deprecated. Use "expect(file).to have_file_size(size)", "expect(all_files).to all have_file_size(1)", "expect(all_files).to include a_file_with_size(1)" instead')
        stop_processes!

        paths_and_sizes.each do |path, size|
          expect(path).to have_file_size size
        end
      end

      # @deprecated
      def check_exact_file_content(file, exact_content, expect_match = true)
        Aruba::Platform.deprecated('The use of "#check_exact_file_content" is deprecated. Use "expect(file).to have_file_content(content)" with a string')

        check_file_content(file, exact_content, expect_match)
      end

      # @deprecated
      # Check if the content of file against the content of a reference file
      #
      # @param [String] file
      #   The file to be checked
      #
      # @param [String] reference_file
      #   The reference file
      #
      # @param [true, false] expect_match
      #   Must the content be in the file or not
      def check_binary_file_content(file, reference_file, expect_match = true)
        Aruba::Platform.deprecated('The use of "#check_binary_file_content" is deprecated. Use "expect(file).to have_same_file_content_like(file)"')

        stop_processes!

        if expect_match
          expect(file).to have_same_file_content_like reference_file
        else
          expect(file).not_to have_same_file_content_like reference_file
        end
      end

      # @deprecated
      # Check presence of a directory
      #
      # @param [Array] paths
      #   The paths to be checked
      #
      # @param [true, false] expect_presence
      #   Should the directory be there or should the directory not be there
      def check_directory_presence(paths, expect_presence)
        Aruba::Platform.deprecated('The use of "#check_directory_presence" is deprecated. Use "expect(directory).to be_an_existing_directory"')

        stop_processes!

        paths.each do |path|
          path = expand_path(path)

          if expect_presence
            expect(path).to be_an_existing_directory
          else
            expect(path).not_to be_an_existing_directory
          end
        end
      end

      # @deprecated
      def prep_for_fs_check(&block)
        Aruba::Platform.deprecated('The use of "prep_for_fs_check" is deprecated. Use apropriate methods and the new rspec matchers instead')

        process_monitor.stop_processes!
        cd('') { block.call }
      end

      # @deprecated
      def assert_exit_status_and_partial_output(expect_to_pass, expected)
        Aruba::Platform.deprecated('The use of "assert_exit_status_and_partial_output" is deprecated. Use "#assert_access" and "#assert_partial_output" instead')

        assert_success(expect_to_pass)
        assert_partial_output(expected, all_output)
      end

      # TODO: Remove this. Call more methods elsewhere instead. Reveals more intent.
      # @deprecated
      def assert_exit_status_and_output(expect_to_pass, expected_output, expect_exact_output)
        assert_success(expect_to_pass)
        if expect_exact_output
          assert_exact_output(expected_output, all_output)
        else
          assert_partial_output(expected_output, all_output)
        end
      end

      # Check the content of file
      #
      # It supports partial content as well. And it is up to you to decided if
      # the content must be there or not.
      #
      # @param [String] file
      #   The file to be checked
      #
      # @param [String, Regexp] content
      #   The content which must/must not be in the file. If content is
      #   a String exact match is done, if content is a Regexp then file
      #   is matched using regular expression
      #
      # @param [true, false] expect_match
      #   Must the content be in the file or not
      def check_file_content(file, content, expect_match = true)
        Aruba::Platform.deprecated('The use of "#check_file_content" is deprecated. Use "expect(file).to have_file_content(content)" instead. For eq match use string, for partial match use /regex/')

        stop_processes!

        if expect_match
          expect(file).to have_file_content content
        else
          expect(file).not_to have_file_content content
        end
      end

      # @deprecated
      def _mkdir(dir_name)
        Aruba::Platform.deprecated('The use of "#_mkdir" is deprecated')

        Aruba::Platform.mkdir(dir_name)
      end

      # @deprecated
      def _rm(dir_name)
        Aruba::Platform.deprecated('The use of "#_rm_rf" is deprecated')

        Aruba::Platform.rm(dir_name)
      end

      # @deprecated
      def current_dir(*args, &block)
        Aruba::Platform.deprecated('The use of "#current_dir" is deprecated. Use "#current_directory" instead')

        current_directory(*args, &block)
      end

      # @deprecated
      def clean_current_dir(*args, &block)
        Aruba::Platform.deprecated('The use of "clean_current_dir" is deprecated. Either use "#setup_aruba" or `#remove(\'.\') to clean up aruba\'s working directory before your tests are run')

        setup_aruba
      end

      # @deprecated
      def in_current_dir(&block)
        Aruba::Platform.deprecated('The use of "in_current_dir" is deprecated. Use "#cd(\'.\') { }" instead')

        create_directory '.' unless directory?('.')
        cd('.', &block)
      end

      # @deprecated
      # Run block with environment
      #
      # @param [Hash] env
      #   The variables to be used for block.
      #
      # @yield
      #   The block of code which should be run with the modified environment variables
      def with_env(env = {}, &block)
        Aruba::Platform.deprecated('The use of "#with_env" is deprecated. Use "#with_environment {}" instead. But be careful this uses a different implementation')

        env.each do |k,v|
          set_env k, v
        end
        block.call
        restore_env
      end

      # @deprecated
      # Restore original process environment
      def restore_env
        # No output because we need to reset env on each scenario/spec run
        # Aruba::Platform.deprecated('The use of "#restore_env" is deprecated. If you use "set_environment_variable" there\'s no need to restore the environment')

        original_env.each do |key, value|
          if value
            ENV[key] = value
          else
            ENV.delete key
          end
        end
      end

      # @deprecated
      # Set environment variable
      #
      # @param [String] key
      #   The name of the environment variable as string, e.g. 'HOME'
      #
      # @param [String] value
      #   The value of the environment variable. Needs to be a string.
      def set_env(key, value)
        Aruba::Platform.deprecated('The use of "#set_env" is deprecated. Please use "set_environment_variable" instead. But be careful, this method uses a different kind of implementation')

        announcer.announce(:environment, key, value)
        original_env[key] = ENV.delete(key) unless original_env.key? key
        ENV[key] = value
      end

      # @deprecated
      def original_env
        # Aruba::Platform.deprecated('The use of "#original_env" is deprecated.')

        @original_env ||= {}
      end

      # @deprecated
      def filesystem_permissions(*args)
        Aruba::Platform.deprecated('The use of "#filesystem_permissions" is deprecated. Please use "#chmod" instead.')

        chmod(*args)
      end

      # Check file system permissions of file
      #
      # @param [Octal] expected_permissions
      #   Expected file system permissions, e.g. 0755
      # @param [String] file_names
      #   The file name(s)
      # @param [Boolean] expected_result
      #   Are the permissions expected to be mode or are they expected not to be mode?
      def check_filesystem_permissions(*args)
        Aruba::Platform.deprecated('The use of "#check_filesystem_permissions" is deprecated. Please use "expect().to have_permissions perms" instead.')

        args = args.flatten

        expected_permissions = args.shift
        expected_result      = args.pop

        args.each do |p|
          raise "Expected #{p} to be present" unless exist? p

          if expected_result
            expect(p).to have_permissions expected_permissions
          else
            expect(p).not_to have_permissions expected_permissions
          end
        end
      end

      # @deprecated
      def _create_file(name, content, check_presence)
        Aruba::Platform.deprecated('The use of "#_create_file" is deprecated. It will be removed soon.')

        ArubaFileCreator.new.write(expand_path(name), content, check_presence)

        self
      end

      # @deprecated
      def _create_fixed_size_file(file_name, file_size, check_presence)
        Aruba::Platform.deprecated('The use of "#_create_fixed_size_file" is deprecated. It will be removed soon.')

        ArubaFixedSizeFileCreator.new.write(expand_path(name), size, check_presence)

        self
      end

      # @deprecated
      # Unescape string
      #
      # @param [String] string
      #   The string which should be unescaped, e.g. the output of a command
      #
      # @return
      #   The string stripped from escape sequences
      def unescape(string)
        Aruba::Platform.deprecated('The use of "#unescape" is deprecated. Use "Aruba::Platform.unescape" instead')

        Aruba::Platform.unescape(string, aruba.config.keep_ansi)
      end

      # @deprecated
      # The root directory of aruba
      def root_directory
        Aruba::Platform.deprecated('The use of "#root_directory" is deprecated. Use "aruba.root_directory" instead')

        aruba.root_directory
      end
      # The path to the directory which contains fixtures
      # You might want to overwrite this method to place your data else where.
      #
      # @return [String]
      #   The directory to where your fixtures are stored
      def fixtures_directory
        Aruba::Platform.deprecated('The use of "#fixtures_directory" is deprecated. Use "aruba.fixtures_directory" instead')

        aruba.fixtures_directory
      end

      # @deprecated
      # rubocop:disable Metrics/CyclomaticComplexity
      # rubocop:disable Metrics/MethodLength
      def check_for_deprecated_variables
        if defined? @aruba_io_wait_seconds
          Aruba::Platform.deprecated('The use of "@aruba_io_wait_seconds" is deprecated. Use "#aruba.config.io_wait_timeout = <numeric>" instead')
          aruba.config.io_wait_timeout = @aruba_io_wait_seconds
        end

        if root_directory != aruba.config.root_directory
          Aruba::Platform.deprecated('Overwriting of methods for configuration is deprecated. Use "#aruba.config.root_directory = <string>" instead')
          aruba.config.root_directory = root_directory
        end

        if current_directory != aruba.config.current_directory
          Aruba::Platform.deprecated('Overwriting of methods for configuration is deprecated. Use "#aruba.config.current_directory = <string>" instead')
          aruba.config.current_directory = current_directory
        end

        if defined? @keep_ansi
          Aruba::Platform.deprecated('The use of "@aruba_keep_ansi" is deprecated. Use "#aruba.config.keep_ansi = <true|false>" instead')
          aruba.config.keep_ansi = @keep_ansi
        end

        if defined? @aruba_root_directory
          Aruba::Platform.deprecated('The use of "@aruba_root_directory" is deprecated. Use "#aruba.config.root_directory = <string>" instead')
          aruba.config.keep_ansi = @aruba_root_directory
        end

        if root_directory != aruba.config.root_directory
          Aruba::Platform.deprecated('Overwriting of methods for configuration of "root_directory" is deprecated.')
          aruba.config.root_directory = root_directory
        end
      end
      # rubocop:enable Metrics/CyclomaticComplexity
      # rubocop:enable Metrics/MethodLength
    end
  end
end
