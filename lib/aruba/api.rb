require 'fileutils'
require 'rbconfig'
require 'rspec/expectations'
require 'aruba'
require 'aruba/config'

Dir.glob( File.join( File.expand_path( '../matchers' , __FILE__ )  , '*.rb' ) ).each { |rb| require rb }

module Aruba
  module Api
    include RSpec::Matchers

    # Expand file name
    #
    # @param [String] file_name
    #   Name of file
    #
    # @return [String]
    #   The full path
    #
    # @example Single file name
    #
    #   # => <path>/tmp/aruba/file
    #   absolute_path('file')
    #
    # @example Single Dot
    #
    #   # => <path>/tmp/aruba
    #   absolute_path('.')
    #
    # @example Join and Expand path
    #
    #   # => <path>/tmp/aruba/path/file
    #   absolute_path('path', 'file')
    #
    def absolute_path(*args)
      in_current_dir { File.expand_path File.join(*args) }
    end

    # Execute block in current directory
    #
    # @yield
    #   The block which should be run in current directory
    def in_current_dir(&block)
      _mkdir(current_dir)
      Dir.chdir(current_dir, &block)
    end

    # Clean the current directory
    def clean_current_dir
      _rm_rf(current_dir)
      _mkdir(current_dir)
    end

    # Get access to current dir
    #
    # @return
    #   Current directory
    def current_dir
      File.join(*dirs)
    end

    # Switch to directory
    #
    # @param [String] dir
    #   The directory
    def cd(dir)
      dirs << dir
      raise "#{current_dir} is not a directory." unless File.directory?(current_dir)
    end

    # The path to the directory which should contain all your test data
    # You might want to overwrite this method to place your data else where.
    #
    # @return [Array]
    #   The directory path: Each subdirectory is a member of an array
    def dirs
      @dirs ||= %w(tmp aruba)
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

    # Create an empty file
    #
    # @param [String] file_name
    #   The name of the file
    def touch_file(file_name)
      in_current_dir do
        file_name = File.expand_path(file_name)
        _mkdir(File.dirname(file_name))

        FileUtils.touch file_name
      end

      self
    end

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
      in_current_dir do
        file_name = File.expand_path(file_name)

        raise "expected #{file_name} to be present" if check_presence && !File.file?(file_name)

        _mkdir(File.dirname(file_name))
        File.open(file_name, 'w') { |f| f << file_content }
      end

      self
    end

    # Change file system  permissions of file
    #
    # @param [Octal] mode
    #   File system mode, eg. 0755
    #
    # @param [String] file_name
    #   Name of file to be modified. This file needs to be present to succeed
    def filesystem_permissions(mode, file_name)
      in_current_dir do
        file_name = File.expand_path(file_name)

        raise "expected #{file_name} to be present" unless FileTest.exists?(file_name)
        if mode.kind_of? String
          FileUtils.chmod(mode.to_i(8),file_name)
        else
          FileUtils.chmod(mode, file_name)
        end
      end
    end

    # @private
    # @deprecated
    def chmod(*args, &block)
      warn('The use of "chmod" is deprecated. Use "filesystem_permissions" instead')

      filesystem_permissions(*args, &block)
    end

    # Check file system permissions of file
    #
    # @param [Octal] mode
    #   Expected file system permissions, e.g. 0755
    # @param [String] file_name
    #   Expected file system permissions, e.g. 0755
    # @param [Boolean] expect_permissions
    #   Are the permissions expected to be mode or are they expected not to be mode?
    def check_filesystem_permissions(mode, file_name, expect_permissions)
      in_current_dir do
        file_name = File.expand_path(file_name)

        raise "expected #{file_name} to be present" unless FileTest.exists?(file_name)
        if mode.kind_of? Integer
          expected_mode = mode.to_s(8)
        else
          expected_mode = mode.gsub(/^0*/, '')
        end

        file_mode = sprintf( "%o", File::Stat.new(file_name).mode )[-4,4].gsub(/^0*/, '')

        if expect_permissions
          expect(file_mode).to eq expected_mode
        else
          expect(file_mode).not_to eq expected_mode
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
      in_current_dir do
        file_name = File.expand_path(file_name)

        raise "expected #{file_name} to be present" if check_presence && !File.file?(file_name)
        _mkdir(File.dirname(file_name))
        File.open(file_name, "wb"){ |f| f.seek(file_size - 1); f.write("\0") }
      end
    end

    # Remove file
    #
    # @param [String] file_name
    #    The file which should be deleted in current directory
    def remove_file(file_name)
      in_current_dir do
        file_name = File.expand_path(file_name)

        FileUtils.rm(file_name)
      end
    end

    # Append data to file
    #
    # @param [String] file_name
    #   The name of the file to be used
    #
    # @param [String] file_content
    #   The content which should be appended to file
    def append_to_file(file_name, file_content)
      in_current_dir do
        file_name = File.expand_path(file_name)

        _mkdir(File.dirname(file_name))
        File.open(file_name, 'a') { |f| f << file_content }
      end
    end

    # Create a directory in current directory
    #
    # @param [String] directory_name
    #   The name of the directory which should be created
    def create_dir(directory_name)
      in_current_dir do
        _mkdir(directory_name)
      end

      self
    end

    # Remove directory
    #
    # @param [String] directory_name
    #   The name of the directory which should be removed
    def remove_dir(directory_name)
      in_current_dir do
        directory_name = File.expand_path(directory_name)

        FileUtils.rmdir(directory_name)
      end
    end

    # Check if paths are present
    #
    # @param [#each] paths
    #   The paths which should be checked
    #
    # @param [true,false] expect_presence
    #   Should the given paths be present (true) or absent (false)
    def check_file_presence(paths, expect_presence = true)
      prep_for_fs_check do
        Array(paths).each do |path|
          if path.kind_of? Regexp
            if expect_presence
              expect(Dir.glob('**/*')).to include_regexp(path)
            else
              expect(Dir.glob('**/*')).not_to include_regexp(path)
            end
          else
            path = File.expand_path(path)

            if expect_presence
              expect(File).to be_file(path)
            else
              expect(File).not_to be_file(path)
            end
          end
        end
      end
    end

    # Pipe data in file
    #
    # @param [String] file_name
    #   The file which should be used to pipe in data
    def pipe_in_file(file_name)
      in_current_dir do
        file_name = File.expand_path(file_name)

        File.open(file_name, 'r').each_line do |line|
          _write_interactive(line)
        end
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
      prep_for_fs_check do
        paths_and_sizes.each do |path, size|
          path = File.expand_path(path)

          expect(File.size(path)).to eq size
        end
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
      prep_for_fs_check do
        file = File.expand_path(file)

        content = IO.read(file)
        yield(content)
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
      match_content =
        if(Regexp === content)
          match(content)
        else
          eq(content)
        end
      prep_for_fs_check do
        content = IO.read(File.expand_path(file))
        if expect_match
          expect(content).to match_content
        else
          expect(content).not_to match_content
        end
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
      prep_for_fs_check do
        identical = FileUtils.compare_file(file, reference_file)
        if expect_match
          expect(identical).to be(true), "The file \"#{file}\" differs from file \"#{reference_file}\""
        else
          expect(identical).not_to be(true), "The file \"#{file}\" is identical to file \"#{reference_file}\""
        end
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
      prep_for_fs_check do
        paths.each do |path|
          path = File.expand_path(path)

          if expect_presence
            expect(File).to be_directory(path)
          else
            expect(File).not_to be_directory(path)
          end
        end
      end
    end

    # @private
    def prep_for_fs_check(&block)
      stop_processes!
      in_current_dir{ block.call }
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
    #   The comand
    def output_from(cmd)
      cmd = detect_ruby(cmd)
      get_process(cmd).output
    end

    # Fetch stdout from command
    #
    # @param [String] cmd
    #   The comand
    def stdout_from(cmd)
      cmd = detect_ruby(cmd)
      get_process(cmd).stdout
    end

    # Fetch stderr from command
    #
    # @param [String] cmd
    #   The comand
    def stderr_from(cmd)
      cmd = detect_ruby(cmd)
      get_process(cmd).stderr
    end

    # Get stdout of all processes
    #
    # @return [String]
    #   The stdout of all process which have run before
    def all_stdout
      stop_processes!
      only_processes.inject("") { |out, ps| out << ps.stdout }
    end

    # Get stderr of all processes
    #
    # @return [String]
    #   The stderr of all process which have run before
    def all_stderr
      stop_processes!
      only_processes.inject("") { |out, ps| out << ps.stderr }
    end

    # Get stderr and stdout of all processes
    #
    # @return [String]
    #   The stderr and stdout of all process which have run before
    def all_output
      all_stdout << all_stderr
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
      expect(unescape(actual)).to match /#{unescape(expected)}/m
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
      unescape(_read_interactive).include?(unescape(expected)) ? true : false
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

    # Check exit status of process
    #
    # @return [TrueClass, FalseClass]
    #   If arg1 is true, return true if command was successful
    #   If arg1 is false, return true if command failed
    def assert_success(success)
      success ? assert_exit_status(0) : assert_not_exit_status(0)
    end

    # @private
    def assert_exit_status(status)
      expect(last_exit_status).to eq(status),
        append_output_to("Exit status was #{last_exit_status} but expected it to be #{status}.")
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
      @processes ||= []
    end

    # @private
    def stop_processes!
      processes.each do |_, process|
        stop_process(process)
      end
    end

    # Terminate all running processes
    def terminate_processes!
      processes.each do |_, process|
        terminate_process(process)
        stop_process(process)
      end
    end

    # @private
    def register_process(name, process)
      processes << [name, process]
    end

    # @private
    def get_process(wanted)
      matching_processes = processes.reverse.find{ |name, _| name == wanted }
      raise ArgumentError.new("No process named '#{wanted}' has been started") unless matching_processes
      matching_processes.last
    end

    # @private
    def only_processes
      processes.collect{ |_, process| process }
    end

    # Run given command and stop it if timeout is reached
    #
    # @param [String] cmd
    #   The command which should be executed
    #
    # @param [Integer] timeout
    #   If the timeout is reached the command will be killed
    def run(cmd, timeout = nil)
      timeout ||= exit_timeout
      @commands ||= []
      @commands << cmd

      cmd = detect_ruby(cmd)

      in_current_dir do
        Aruba.config.hooks.execute(:before_cmd, self, cmd)

        announcer.dir(Dir.pwd)
        announcer.cmd(cmd)

        process = Aruba.process.new(cmd, timeout, io_wait)
        register_process(cmd, process)
        process.run!

        block_given? ? yield(process) : process
      end
    end

    DEFAULT_TIMEOUT_SECONDS = 3

    # Default exit timeout for running commands with aruba
    #
    # Overwrite this method if you want a different timeout or set
    # `@aruba_timeout_seconds`.
    def exit_timeout
      @aruba_timeout_seconds || DEFAULT_TIMEOUT_SECONDS
    end

    DEFAULT_IO_WAIT_SECONDS = 0.1

    # Default io wait timeout
    #
    # Overwrite this method if you want a different timeout or set
    # `@aruba_io_wait_seconds
    def io_wait
      @aruba_io_wait_seconds || DEFAULT_IO_WAIT_SECONDS
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
      run(cmd, timeout) do |process|
        stop_process(process)
      end
      @timed_out = last_exit_status.nil?
      assert_exit_status(0) if fail_on_error
    end

    # Run a command interactively
    #
    # @param [String] cmd
    #   The command to by run
    #
    # @see #cmd
    def run_interactive(cmd)
      @interactive = run(cmd)
    end

    # Provide data to command via stdin
    #
    # @param [String] input
    #   The input for the command
    def type(input)
      return close_input if "" == input
      _write_interactive(_ensure_newline(input))
    end

    # Close stdin
    def close_input
      @interactive.stdin.close
    end

    # @deprecated
    # @private
    def eot
      warn(%{\e[35m    The \"#eot\"-method is deprecated. It will be deleted with the next major version. Please use \"#close_input\"-method instead.\e[0m})
      close_input
    end

    # @private
    def _write_interactive(input)
      @interactive.stdin.write(input)
      @interactive.stdin.flush
    end

    # @private
    def _read_interactive
      @interactive.read_stdout
    end

    # @private
    def _ensure_newline(str)
      str.chomp << "\n"
    end

    # @private
    def announce_or_puts(msg)
      if(@puts)
        Kernel.puts(msg)
      else
        puts(msg)
      end
    end

    # @private
    def detect_ruby(cmd)
      if cmd =~ /^ruby\s/
        cmd.gsub(/^ruby\s/, "#{current_ruby} ")
      else
        cmd
      end
    end

    # @private
    def current_ruby
      File.join(RbConfig::CONFIG['bindir'], RbConfig::CONFIG['ruby_install_name'])
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
      announcer.env(key, value)
      original_env[key] = ENV.delete(key) unless original_env.key? key
      ENV[key] = value
    end

    # Restore original process environment
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

    # TODO: move some more methods under here!

    private

    def last_exit_status
      return @last_exit_status if @last_exit_status
      stop_processes!
      @last_exit_status
    end

    def stop_process(process)
      @last_exit_status = process.stop(announcer)
    end

    def terminate_process(process)
      process.terminate
    end

    def announcer
      Announcer.new(self,
                    :stdout => @announce_stdout,
                    :stderr => @announce_stderr,
                    :dir => @announce_dir,
                    :cmd => @announce_cmd,
                    :env => @announce_env)
    end

    class Announcer
      def initialize(session, options = {})
        @session, @options = session, options
      end

      def stdout(content)
        return unless @options[:stdout]
        print content
      end

      def stderr(content)
        return unless @options[:stderr]
        print content
      end

      def dir(dir)
        return unless @options[:dir]
        print "$ cd #{dir}"
      end

      def cmd(cmd)
        return unless @options[:cmd]
        print "$ #{cmd}"
      end

      def env(key, value)
        return unless @options[:env]
        print %{$ export #{key}="#{value}"}
      end

      private

      def print(message)
        @session.announce_or_puts(message)
      end
    end

  end
end
