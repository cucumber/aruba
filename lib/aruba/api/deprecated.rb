module Aruba
  module Api
    module Deprecated
      # @private
      # @deprecated
      def detect_ruby(cmd)
        warn('The use of "#detect_ruby" is deprecated. Use "Aruba::Platform.detect_ruby" instead.')

        Aruba::Platform.detect_ruby cmd
      end

      # @private
      # @deprecated
      def current_ruby
        warn('The use of "#current_ruby" is deprecated. Use "Aruba::Platform.current_ruby" instead.')

        Aruba::Platform.current_ruby cmd
      end

      # @private
      # @deprecated
      def _ensure_newline(str)
        warn('The use of "#_ensure_newline" is deprecated. Use "Aruba::Platform.ensure_newline" instead.')

        Aruba::Platform.ensure_newline cmd
      end

      # @private
      # @deprecated
      def absolute_path(*args)
        warn('The use of "absolute_path" is deprecated. Use "expand_path" instead. But be aware that "expand_path" uses a different implementation.')

        in_current_directory { File.expand_path File.join(*args) }
      end

      # @private
      # @deprecated
      def _read_interactive
        warn('The use of "#_read_interactive" is deprecated. Please use "last_command.stdout" instead.')

        last_command.stdout
      end

      # @private
      # @deprecated
      def announce_or_puts(msg)
        warn('The use of "#announce_or_puts" is deprecated. Please use "#announcer.mode = :kernel" or "#announcer.mode = :puts" instead.')

        if(@puts)
          Kernel.puts(msg)
        else
          puts(msg)
        end
      end

      # @private
      # @deprecated
      def _write_interactive(input)
        warn('The use of "#_write_interactive" is deprecated. Please use "#last_command.write()" instead.')

        last_command.write(input)
      end

      # @deprecated
      # @private
      def eot
        warn(%{\e[35m    The \"#eot\"-method is deprecated. It will be deleted with the next major version. Please use \"#close_input\"-method instead.\e[0m})

        close_input
      end

      # Run a command interactively
      #
      # @param [String] cmd
      #   The command to by run
      #
      # @see #cmd
      # @deprectated
      # @private
      def run_interactive(cmd)
        warn('The use of "#run_interactive" is deprecated. You can simply use "run" instead.')

        run(cmd)
      end

      # @private
      # @deprecated
      # Create an empty file
      #
      # @param [String] file_name
      #   The name of the file
      def touch_file(*args)
        warn('The use of "#touch_file" is deprecated. Use "#touch" instead')

        touch(*args)
      end

      # @private
      # @deprecated
      def chmod(*args, &block)
        warn('The use of "#chmod" is deprecated. Use "#filesystem_permissions" instead')

        filesystem_permissions(*args, &block)
      end

      # @private
      # @deprecated
      def mod?(*args, &block)
        warn('The use of "#mod?" is deprecated. Use "#check_filesystem_permissions" instead')

        check_filesystem_permissions(*args, &block)
      end

      # @private
      # @deprecated
      # Remove file
      #
      # @param [String] file_name
      #    The file which should be deleted in current directory
      def remove_file(*args)
        warn('The use of "#remove_file" is deprecated. Use "#remove" instead')

        remove(*args)
      end

      # @private
      # @deprecated
      def create_dir(*args)
        warn('The use of "#create_dir" is deprecated. Use "#create_directory" instead')
        create_directory(*args)
      end

      # @private
      # @deprecated
      # Remove directory
      #
      # @param [String] directory_name
      #   The name of the directory which should be removed
      def remove_directory(*args)
        warn('The use of "remove_directory" is deprecated. Use "remove" instead')
        remove(*args)
      end

      # @private
      # @deprecated
      def remove_dir(*args)
        warn('The use of "remove_dir" is deprecated. Use "remove" instead')
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
        warn('The use of "check_file_presence" is deprecated. Use "expect().to be_existing_file or expect(all_paths).to match_path_pattern() instead" ')

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
      # @private
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
        warn('The use of "#check_file_size" is deprecated. Use "expect(file).to have_file_size(size)", "expect(all_files).to all have_file_size(1)", "expect(all_files).to include a_file_with_size(1)" instead.')
        stop_processes!

        paths_and_sizes.each do |path, size|
          expect(path).to have_file_size size
        end
      end

      # @private
      # @deprecated
      def check_exact_file_content(file, exact_content, expect_match = true)
        warn('The use of "#check_exact_file_content" is deprecated. Use "expect(file).to have_file_content(content)" with a string')

        check_file_content(file, exact_content, expect_match)
      end

      # @deprecated
      # @private
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
        warn('The use of "#check_binary_file_content" is deprecated. Use "expect(file).to have_same_file_content_like(file)".')

        stop_processes!

        if expect_match
          expect(file).to have_same_file_content_like reference_file
        else
          expect(file).not_to have_same_file_content_like reference_file
        end
      end

      # @deprecated
      # @private
      # Check presence of a directory
      #
      # @param [Array] paths
      #   The paths to be checked
      #
      # @param [true, false] expect_presence
      #   Should the directory be there or should the directory not be there
      def check_directory_presence(paths, expect_presence)
        warn('The use of "#check_directory_presence" is deprecated. Use "expect(directory).to be_an_existing_directory".')

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

      # @private
      # @deprecated
      def prep_for_fs_check(&block)
        warn('The use of "prep_for_fs_check" is deprecated. Use apropriate methods and the new rspec matchers instead.')

        process_monitor.stop_processes!
        in_current_directory{ block.call }
      end

      # @private
      # @deprecated
      def assert_exit_status_and_partial_output(expect_to_pass, expected)
        warn('The use of "assert_exit_status_and_partial_output" is deprecated. Use "#assert_access" and "#assert_partial_output" instead.')

        assert_success(expect_to_pass)
        assert_partial_output(expected, all_output)
      end

      # TODO: Remove this. Call more methods elsewhere instead. Reveals more intent.
      # @private
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
        warn('The use of "#check_file_content" is deprecated. Use "expect(file).to have_file_content" instead.')

        stop_processes!

        if expect_match
          expect(content).to have_file_content content
        else
          expect(content).not_to have_file_content content
        end
      end
    end
  end
end
