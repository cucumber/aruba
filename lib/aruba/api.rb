require 'aruba'

Dir.glob( File.join( File.expand_path( '../matchers' , __FILE__ )  , '*.rb' ) ).each { |rb| require rb }

module Aruba
  module Api
    include RSpec::Matchers
    include Aruba::Utils
    include Aruba::Api::Core

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
        in_current_directory { File.expand_path file_name, dir_string }
      end
    end

    # @private
    # @deprecated
    def absolute_path(*args)
      warn('The use of "absolute_path" is deprecated. Use "expand_path" instead. But be aware that "expand_path" uses a different implementation.')

      in_current_directory { File.expand_path File.join(*args) }
    end

    # Check if file or directory exist
    #
    # @param [String] file_or_directory
    #   The file/directory which should exist
    def exist?(file_or_directory)
      File.exist? expand_path(file_or_directory)
    end

    # Check if file exist and is file
    #
    # @param [String] file
    #   The file/directory which should exist
    def file?(file)
      File.file? expand_path(file)
    end

    # Check if directory exist and is directory
    #
    # @param [String] file
    #   The file/directory which should exist
    def directory?(file)
      File.directory? expand_path(file)
    end

    # Check if path is absolute
    #
    # @return [TrueClass, FalseClass]
    #   Result of check
    def absolute?(path)
      Pathname.new(path).absolute?
    end

    # Check if path is relative
    #
    # @return [TrueClass, FalseClass]
    #   Result of check
    def relative?(path)
      Pathname.new(path).relative?
    end

    # Return all existing paths (directories, files) in current dir
    #
    # @return [Array]
    #   List of files and directories
    def all_paths
      list('.').map { |p| expand_path(p) }
    end

    # Return all existing files in current directory
    #
    # @return [Array]
    #   List of files
    def all_files
      list('.').select { |p| file? p }.map { |p| expand_path(p) }
    end

    # Return all existing directories in current directory
    #
    # @return [Array]
    #   List of files
    def all_directories
      list('.').select { |p| directory? p }.map { |p| expand_path(p) }
    end

    # Create directory object
    #
    # @return [Dir]
    #   The directory object
    def directory(path)
      fail ArgumentError, %(Path "#{name}" does not exist.) unless exist? name

      Dir.new(expand_path(path))
    end

    # Return content of directory
    #
    # @return [Array]
    #   The content of directory
    def list(name)
      fail ArgumentError, %(Path "#{name}" does not exist.) unless exist? name
      fail ArgumentError, %(Only directories are supported. Path "#{name}" is not a directory.) unless directory? name

      existing_files            = Dir.glob(expand_path(File.join(name, '**', '*')))
      current_working_directory = Pathname.new(expand_path('.'))

      existing_files.map { |d| Pathname.new(d).relative_path_from(current_working_directory).to_s }
    end

    # Return content of file
    #
    # @return [Array]
    #   The content of file
    def read(name)
      fail ArgumentError, %(Path "#{name}" does not exist.) unless exist? name
      fail ArgumentError, %(Only files are supported. Path "#{name}" is not a file.) unless file? name

      File.readlines(expand_path(name))
    end

    # Create a file with given content
    #
    # The method does not check if file already exists. If the file name is a
    # path the method will create all neccessary directories.
    #
    # @param [String] file_name
    #   The name of the file
    #
    # @param [String] file_content
    #   The content which should be written to the file
    def write_file(file_name, file_content)
      _create_file(file_name, file_content, false)
    end

    # @private
    # @deprecated
    # Create an empty file
    #
    # @param [String] file_name
    #   The name of the file
    def touch_file(*args)
      warn('The use of "touch_file" is deprecated. Use "touch" instead')

      touch(*args)
    end

    # Create an empty file
    #
    # @param [String] file_name
    #   The name of the file
    def touch(*args)
      args = args.flatten

      options = if args.last.kind_of? Hash
                  args.pop
                else
                  {}
                end

      args = args.map { |p| expand_path(p) }
      args.each { |p| _mkdir(File.dirname(p)) }

      FileUtils.touch(args, options)

      self
    end

    # Copy a file and/or directory
    #
    # @param [String, Array] source
    #   A single file or directory, multiple files or directories or multiple
    #   files and directories. If multiple sources are given the destination
    #   needs to be a directory
    #
    # @param [String] destination
    #   A file or directory name. If multiple sources are given the destination
    #   needs to be a directory
    #
    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/PerceivedComplexity
    def copy(*source, destination)
      source = source.flatten

      source.each do |s|
        raise ArgumentError, %(The following source "#{s}" does not exist.) unless exist? s
      end

      raise ArgumentError, "Using a fixture as destination (#{destination}) is not supported" if destination.start_with? aruba.config.fixtures_path_prefix
      raise ArgumentError, "Multiples sources can only be copied to a directory" if source.count > 1 && exist?(destination) && !directory?(destination)

      source_paths     = source.map { |f| expand_path(f) }
      destination_path = expand_path(destination)

      if source_paths.count > 1
        _mkdir(destination_path)
      else
        _mkdir(File.dirname(destination_path))
        source_paths = source_paths.first
      end

      FileUtils.cp_r source_paths, destination_path

      self
    end
    # rubocop:enable Metrics/PerceivedComplexity
    # rubocop:enable Metrics/CyclomaticComplexity

    # Create a file with the given size
    #
    # The method does not check if file already exists. If the file name is a
    # path the method will create all neccessary directories.
    #
    # @param [String] file_name
    #   The name of the file
    #
    # @param [Integer] file_size
    #   The size of the file
    def write_fixed_size_file(file_name, file_size)
      _create_fixed_size_file(file_name, file_size, false)
    end

    # Create a file with given content
    #
    # The method does check if file already exists and fails if the file is
    # missing. If the file name is a path the method will create all neccessary
    # directories.
    def overwrite_file(file_name, file_content)
      _create_file(file_name, file_content, true)
    end

    # @private
    def _create_file(file_name, file_content, check_presence)
      file_name = expand_path(file_name)

      raise "expected #{file_name} to be present" if check_presence && !File.file?(file_name)

      _mkdir(File.dirname(file_name))
      File.open(file_name, 'w') { |f| f << file_content }

      self
    end

    # Change file system  permissions of file
    #
    # @param [Octal] mode
    #   File system mode, eg. 0755
    #
    # @param [String] file_name
    #   Name of file to be modified. This file needs to be present to succeed
    def filesystem_permissions(*args)
      args = args.flatten

      options = if args.last.kind_of? Hash
                  args.pop
                else
                  {}
                end

      mode = args.shift
      mode = if mode.kind_of? String
               mode.to_i(8)
             else
               mode
             end

      args = args.map { |p| expand_path(p) }
      args.each { |p| raise "Expected #{p} to be present" unless FileTest.exists?(p) }

      FileUtils.chmod(mode, args, options)

      self
    end

    # @private
    # @deprecated
    def chmod(*args, &block)
      warn('The use of "chmod" is deprecated. Use "filesystem_permissions" instead')

      filesystem_permissions(*args, &block)
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
      args = args.flatten

      expected_permissions = args.shift
      expected_result      = args.pop

      args = args.map { |p| expand_path(p) }

      args.each do |p|
        raise "Expected #{p} to be present" unless FileTest.exists?(p)

        if expected_result
          expect(p).to have_permissions expected_permissions
        else
          expect(p).not_to have_permissions expected_permissions
        end
      end
    end

    # @private
    # @deprecated
    def mod?(*args, &block)
      warn('The use of "mod?" is deprecated. Use "check_filesystem_permissions" instead')

      check_filesystem_permissions(*args, &block)
    end

    # @private
    def _create_fixed_size_file(file_name, file_size, check_presence)
      file_name = expand_path(file_name)

      raise "expected #{file_name} to be present" if check_presence && !File.file?(file_name)
      _mkdir(File.dirname(file_name))
      File.open(file_name, "wb"){ |f| f.seek(file_size - 1); f.write("\0") }
    end

    # @private
    # @deprecated
    # Remove file
    #
    # @param [String] file_name
    #    The file which should be deleted in current directory
    def remove_file(*args)
      warn('The use of "remove_file" is deprecated. Use "remove" instead')

      remove(*args)
    end

    # Append data to file
    #
    # @param [String] file_name
    #   The name of the file to be used
    #
    # @param [String] file_content
    #   The content which should be appended to file
    def append_to_file(file_name, file_content)
      file_name = expand_path(file_name)

      _mkdir(File.dirname(file_name))
      File.open(file_name, 'a') { |f| f << file_content }
    end

    # Create a directory in current directory
    #
    # @param [String] directory_name
    #   The name of the directory which should be created
    def create_directory(directory_name)
      FileUtils.mkdir_p expand_path(directory_name)

      self
    end

    # @private
    # @deprecated
    def create_dir(*args)
      warn('The use of "create_dir" is deprecated. Use "create_directory" instead')
      create_directory(*args)
    end

    # Remove file or directory
    #
    # @param [Array, String] name
    #   The name of the file / directory which should be removed
    def remove(*args)
      args = args.flatten

      options = if args.last.kind_of? Hash
                  args.pop
                else
                  {}
                end

      args = args.map { |p| expand_path(p) }

      FileUtils.rm_r(args, options)
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

      stop_commands

      Array(paths).each do |path|
        if path.kind_of? Regexp
          if expect_presence
            expect(all_paths).to match_path_pattern(path)
          else
            expect(all_paths).not_to match_path_pattern(path)
          end
        else
          if expect_presence
            expect(path).to be_existing_file
          else
            expect(path).not_to be_existing_file
          end
        end
      end
    end

    # Pipe data in file
    #
    # @param [String] file_name
    #   The file which should be used to pipe in data
    def pipe_in_file(file_name)
      file_name = expand_path(file_name)

      File.open(file_name, 'r').each_line do |line|
        last_command.write(line)
      end
    end

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
      stop_commands

      paths_and_sizes.each do |path, size|
        path = expand_path(path)

        expect(File.size(path)).to eq size
      end
    end

    # Read content of file and yield the content to block
    #
    # @param [String) file
    #   The name of file which should be read from
    #
    # @yield
    #   Pass the content of the given file to this block
    def with_file_content(file, &block)
      stop_commands

      file = expand_path(file)
      content = IO.read(file)

      yield(content)
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
      stop_commands

      match_content =
        if(Regexp === content)
          match(content)
        else
          eq(content)
        end

      content = IO.read(expand_path(file))

      if expect_match
        expect(content).to match_content
      else
        expect(content).not_to match_content
      end
    end

    # @private
    # @deprecated
    def check_exact_file_content(file, exact_content, expect_match = true)
      warn('The use of "check_exact_file_content" is deprecated. Use "#check_file_content" with a string instead.')

      check_file_content(file, exact_content, expect_match)
    end

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
      if expect_match
        expect(file).to have_same_file_content_like reference_file
      else
        expect(file).not_to have_same_file_content_like reference_file
      end
    end

    # Check presence of a directory
    #
    # @param [Array] paths
    #   The paths to be checked
    #
    # @param [true, false] expect_presence
    #   Should the directory be there or should the directory not be there
    def check_directory_presence(paths, expect_presence)
      stop_commands

      paths.each do |path|
        path = expand_path(path)

        if expect_presence
          expect(File).to be_directory(path)
        else
          expect(File).not_to be_directory(path)
        end
      end
    end

    # @private
    def prep_for_fs_check(&block)
      warn('The use of "prep_for_fs_check" is deprecated. It will be removed soon.')

      aruba.command_monitor.stop_commands
      in_current_directory{ block.call }
    end

    # @private
    def _mkdir(dir_name)
      dir_name = File.expand_path(dir_name)

      FileUtils.mkdir_p(dir_name) unless File.directory?(dir_name)
    end

    # @private
    def _rm_rf(dir_name)
      dir_name = File.expand_path(dir_name)

      FileUtils.rm_rf(dir_name)
    end

    # Unescape string
    #
    # @param [String] string
    #   The string which should be unescaped, e.g. the output of a command
    #
    # @return
    #   The string stripped from escape sequences
    def unescape(string)
      string = string.gsub('\n', "\n").gsub('\"', '"').gsub('\e', "\e")
      string = string.gsub(/\e\[\d+(?>(;\d+)*)m/, '') unless @aruba_keep_ansi
      string
    end

    # Fetch output (stdout, stderr) from command
    #
    # @param [String] cmd
    #   The command
    def output_from(cmd)
      aruba.command_monitor.output_from(cmd)
    end

    # Fetch stdout from command
    #
    # @param [String] cmd
    #   The command
    def stdout_from(cmd)
      aruba.command_monitor.stdout_from(cmd)
    end

    # Fetch stderr from command
    #
    # @param [String] cmd
    #   The command
    def stderr_from(cmd)
      aruba.command_monitor.stderr_from(cmd)
    end

    # Get stdout of all commands
    #
    # @return [String]
    #   The stdout of all command which have run before
    def all_stdout
      aruba.command_monitor.all_stdout
    end

    # Get stderr of all commands
    #
    # @return [String]
    #   The stderr of all command which have run before
    def all_stderr
      aruba.command_monitor.all_stderr
    end

    # Get stderr and stdout of all commands
    #
    # @return [String]
    #   The stderr and stdout of all command which have run before
    def all_output
      aruba.command_monitor.all_output
    end

    # Full compare arg1 and arg2
    #
    # @return [TrueClass, FalseClass]
    #   If arg1 is exactly the same as arg2 return true, otherwise false
    def assert_exact_output(expected, actual)
      actual.force_encoding(expected.encoding) if RUBY_VERSION >= "1.9"
      expect(unescape(actual)).to eq unescape(expected)
    end

    # Partial compare arg1 and arg2
    #
    # @return [TrueClass, FalseClass]
    #   If arg2 contains arg1 return true, otherwise false
    def assert_partial_output(expected, actual)
      actual.force_encoding(expected.encoding) if RUBY_VERSION >= "1.9"
      expect(unescape(actual)).to include(unescape(expected))
    end

    # Regex Compare arg1 and arg2
    #
    # @return [TrueClass, FalseClass]
    #   If arg2 matches arg1 return true, otherwise false
    def assert_matching_output(expected, actual)
      actual.force_encoding(expected.encoding) if RUBY_VERSION >= "1.9"
      expect(unescape(actual)).to match(/#{unescape(expected)}/m)
    end

    # Negative regex compare arg1 and arg2
    #
    # @return [TrueClass, FalseClass]
    #   If arg2 does not match arg1 return true, otherwise false
    def assert_not_matching_output(expected, actual)
      actual.force_encoding(expected.encoding) if RUBY_VERSION >= "1.9"
      expect(unescape(actual)).not_to match(/#{unescape(expected)}/m)
    end

    # Negative partial compare arg1 and arg2
    #
    # @return [TrueClass, FalseClass]
    #   If arg2 does not match/include arg1 return true, otherwise false
    def assert_no_partial_output(unexpected, actual)
      actual.force_encoding(unexpected.encoding) if RUBY_VERSION >= "1.9"
      if Regexp === unexpected
        expect(unescape(actual)).not_to match unexpected
      else
        expect(unescape(actual)).not_to include(unexpected)
      end
    end

    # Partial compare output of interactive command and arg1
    #
    # @return [TrueClass, FalseClass]
    #   If output of interactive command includes arg1 return true, otherwise false
    def assert_partial_output_interactive(expected)
      unescape(last_command.stdout).include?(unescape(expected)) ? true : false
    end

    # Check if command succeeded and if arg1 is included in output
    #
    # @return [TrueClass, FalseClass]
    #   If exit status is 0 and arg1 is included in output return true, otherwise false
    def assert_passing_with(expected)
      assert_success(true)
      assert_partial_output(expected, all_output)
    end

    # Check if command failed and if arg1 is included in output
    #
    # @return [TrueClass, FalseClass]
    #   If exit status is not equal 0 and arg1 is included in output return true, otherwise false
    def assert_failing_with(expected)
      assert_success(false)
      assert_partial_output(expected, all_output)
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

    # Check exit status of command
    #
    # @return [TrueClass, FalseClass]
    #   If arg1 is true, return true if command was successful
    #   If arg1 is false, return true if command failed
    def assert_success(success)
      if success
        expect(last_command).to be_successfully_executed
      else
        expect(last_command).not_to be_successfully_executed
      end
    end

    # @private
    def assert_exit_status(status)
      expect(last_command).to have_exit_status(status)
    end

    # @private
    def assert_not_exit_status(status)
      expect(last_exit_status).not_to eq(status),
        append_output_to("Exit status was #{last_exit_status} which was not expected.")
    end

    # @private
    def append_output_to(message)
      "#{message} Output:\n\n#{all_output}\n"
    end

    # @private
    def processes
      warn('The use of "processes" is deprecated. It will be removed soon. Please use "aruba.command_monitor.commands" instead.')

      aruba.command_monitor.commands
    end

    # @private
    def stop_processes!
      warn('The use of "stop_processes!" is deprecated. It will be removed soon. Please use "#stop_commands" instead.')

      stop_commands
    end

    # Stop all commands
    def stop_commands
      aruba.command_monitor.stop_commands
    end

    # Terminate all running commands
    def terminate_processes!
      warn('The use of "terminate_processes!" is deprecated. Please use "#terminate_commands" instead.')

      terminate_commands
    end

    # Terminate all running commands
    def terminate_commands
      aruba.command_monitor.terminate_commands
    end

    # Return the last command which was started
    #
    # @return [Command]
    #   The command
    def last_command
      aruba.command_monitor.last_command
    end

    # @private
    # @deprecated
    def register_process(name, command)
      warn('The use of "register_processs" is deprecated. It will be removed soon. There\'s no need to register a command anymore. To start a command use "aruba.command_monitor.start_command()". This starts and registers the command for you.')

      aruba.command_monitor.send(:register_command, command)
    end

    # @private
    # @deprecated
    def get_process(wanted)
      warn('The use of "get_process" is deprecated. It will be removed soon. To find a command use "aruba.command_monitor.find()". But be aware that this uses the commandline of the process.')
      aruba.command_monitor.find(wanted)
    end

    # @private
    # @deprecated
    def only_process
      warn('The use of "only_processes" is deprecated. It will be removed soon. To get access to all commands use "#all_commands".')

      all_commands
    end

    # Make all commands available
    #
    # @return [Array]
    #   Array of commands
    def all_commands
      aruba.command_monitor.commands
    end

    # Run given command and stop it if timeout is reached
    #
    # @param [String] cmd
    #   The command which should be executed
    #
    # @param [Integer] timeout
    #   If the timeout is reached the command will be killed
    #
    # @yield [SpawnProcess]
    #   Run block with command
    def run(cmd, timeout = nil)
      timeout ||= exit_timeout
      @commands ||= []
      @commands << cmd

      cmd = detect_ruby(cmd)

      aruba.config.hooks.execute(:before_cmd, self, cmd)
      aruba.event_queue.notify :switched_working_directory, Dir.pwd

      command = aruba.command_monitor.start_command(cmd, timeout, io_wait, expand_path('.'))

      block_given? ? yield(command) : command
    end

    # Default exit timeout for running commands with aruba
    #
    # Overwrite this method if you want a different timeout or set
    # `@aruba_timeout_seconds`.
    def exit_timeout
      aruba.config.exit_timeout
    end

    # Default io wait timeout
    #
    # Overwrite this method if you want a different timeout or set
    # `@aruba_io_wait_seconds
    def io_wait
      aruba.config.io_wait_timeout
    end

    # The root directory of aruba
    def root_directory
      aruba.config.root_directory
    end

    # The path to the directory which contains fixtures
    # You might want to overwrite this method to place your data else where.
    #
    # @return [String]
    #   The directory to where your fixtures are stored
    def fixtures_directory
      unless @fixtures_directory
        candidates = aruba.config.fixtures_directories.map { |dir| File.join(root_directory, dir) }
        @fixtures_directory = candidates.find { |dir| File.directory? dir }
        raise "No fixtures directories are found" unless @fixtures_directory
      end
      raise "#{@fixtures_directory} is not a directory" unless File.directory?(@fixtures_directory)
      @fixtures_directory
    end

    # Run a command with aruba
    #
    # Checks for error during command execution and checks the output to detect
    # an timeout error.
    #
    # @param [String] cmd
    #   The command to be executed
    #
    # @param [TrueClass,FalseClass] fail_on_error
    #   Should aruba fail on error?
    #
    # @param [Integer] timeout
    #   Timeout for execution
    def run_simple(cmd, fail_on_error = true, timeout = nil)
      command = run(cmd, timeout) do |c|
        aruba.command_monitor.stop_command(c)

        c
      end

      @timed_out = command.exit_status.nil?

      expect(command).to be_successfully_executed if fail_on_error
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
      warn('The use of "run_interactive" is deprecated. You can simply use "run" instead.')

      run(cmd)
    end

    # Provide data to command via stdin
    #
    # @param [String] input
    #   The input for the command
    def type(input)
      return close_input if "" == input
      last_command.write(_ensure_newline(input))
    end

    # Close stdin
    def close_input
      last_command.close_io(:stdin)
    end

    # @deprecated
    # @private
    def eot
      warn(%{\e[35m    The \"#eot\"-method is deprecated. It will be deleted with the next major version. Please use \"#close_input\"-method instead.\e[0m})
      close_input
    end

    # @private
    def _write_interactive(input)
      warn('The use of "_write_interactive" is deprecated. It will be removed soon.')

      last_command.write(input)
    end

    # @private
    def _read_interactive
      warn('The use of "_read_interactive" is deprecated. It will be removed soon.')

      last_command.stdout
    end

    # @private
    def _ensure_newline(str)
      Utils.ensure_newline(str)
    end

    # @private
    def announce_or_puts(msg)
      if(@puts)
        Kernel.puts(msg)
      else
        puts(msg)
      end
    end

    # Use a clean rvm gemset
    #
    # Please make sure that you've got [rvm](http://rvm.io/) installed.
    #
    # @param [String] gemset
    #   The name of the gemset to be used
    def use_clean_gemset(gemset)
      run_simple(%{rvm gemset create "#{gemset}"}, true)
      if all_stdout =~ /'#{gemset}' gemset created \((.*)\)\./
        gem_home = Regexp.last_match[1]
        set_env('GEM_HOME', gem_home)
        set_env('GEM_PATH', gem_home)
        set_env('BUNDLE_PATH', gem_home)

        paths = (ENV['PATH'] || "").split(File::PATH_SEPARATOR)
        paths.unshift(File.join(gem_home, 'bin'))
        set_env('PATH', paths.uniq.join(File::PATH_SEPARATOR))

        run_simple("gem install bundler", true)
      else
        raise "I didn't understand rvm's output: #{all_stdout}"
      end
    end

    # Unset variables used by bundler
    def unset_bundler_env_vars
      %w[RUBYOPT BUNDLE_PATH BUNDLE_BIN_PATH BUNDLE_GEMFILE].each do |key|
        set_env(key, nil)
      end
    end

    # Set environment variable
    #
    # @param [String] key
    #   The name of the environment variable as string, e.g. 'HOME'
    #
    # @param [String] value
    #   The value of the environment variable. Needs to be a string.
    def set_env(key, value)
      aruba.event_queue.notify :changed_environment, { key: value }

      original_env[key] = ENV.delete(key) unless original_env.key? key
      ENV[key] = value
    end

    # Restore original command environment
    def restore_env
      original_env.each do |key, value|
        if value
          ENV[key] = value
        else
          ENV.delete key
        end
      end
    end

    # @private
    def original_env
      @original_env ||= {}
    end

    # Run block with environment
    #
    # @param [Hash] env
    #   The variables to be used for block.
    #
    # @yield
    #   The block of code which should be run with the modified environment variables
    def with_env(env = {}, &block)
      env.each do |k,v|
        set_env k, v
      end
      block.call
      restore_env
    end

    # Access to announcer
    def announcer
      @announcer ||= Announcer.new(
        self,
        :stdout => @announce_stdout,
        :stderr => @announce_stderr,
        :dir    => @announce_dir,
        :cmd    => @announce_cmd,
        :env    => @announce_env
      )

      @announcer
    end

    module_function :announcer

    # TODO: move some more methods under here!

    private

    def last_exit_status
      aruba.command_monitor.last_command.exit_status
    end

    def stop_process(command)
      warn('The use of "stop_process" is deprecated. It will be removed soon. Please use `aruba.command_monitor.find(command).stop`.')

      aruba.command_monitor.find(command).stop
    end

    def terminate_process(command)
      warn('The use of "terminate_process" is deprecated. It will be removed soon. Please use `aruba.command_monitor.find(command).terminate`.')

      aruba.command_monitor.find(command).terminate
    end
  end
end
