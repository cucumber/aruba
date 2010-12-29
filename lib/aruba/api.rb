require 'fileutils'
require 'rbconfig'
require 'aruba/process'

module Aruba
  module Api
    def in_current_dir(&block)
      _mkdir(current_dir)
      Dir.chdir(current_dir, &block)
    end

    def current_dir
      File.join(*dirs)
    end

    def cd(dir)
      dirs << dir
      raise "#{current_dir} is not a directory." unless File.directory?(current_dir)
    end

    def dirs
      @dirs ||= ['tmp/aruba']
    end

    def write_file(file_name, file_content)
      _create_file(file_name, file_content, false)
    end

    def overwrite_file(file_name, file_content)
      _create_file(file_name, file_content, true)
    end

    def _create_file(file_name, file_content, check_presence)
      in_current_dir do
        raise "expected #{file_name} to be present" if check_presence && !File.file?(file_name)
        _mkdir(File.dirname(file_name))
        File.open(file_name, 'w') { |f| f << file_content }
      end
    end

    def remove_file(file_name)
      in_current_dir do
        FileUtils.rm(file_name)
      end
    end

    def append_to_file(file_name, file_content)
      in_current_dir do
        File.open(file_name, 'a') { |f| f << file_content }
      end
    end

    def create_dir(dir_name)
      in_current_dir do
        _mkdir(dir_name)
      end
    end

    def check_file_presence(paths, expect_presence)
      prep_for_fs_check do
        paths.each do |path|
          if expect_presence
            File.should be_file(path)
          else
            File.should_not be_file(path)
          end
        end
      end
    end

    def check_file_content(file, partial_content, expect_match)
      regexp = regexp(partial_content)
      prep_for_fs_check do 
        content = IO.read(file)
        if expect_match
          content.should =~ regexp
        else
          content.should_not =~ regexp
        end
      end
    end
  
    def check_exact_file_content(file, exact_content)
      prep_for_fs_check { IO.read(file).should == exact_content }
    end
  
    def check_directory_presence(paths, expect_presence)
      prep_for_fs_check do
        paths.each do |path|
          if expect_presence
            File.should be_directory(path)
          else
            File.should_not be_directory(path)
          end
        end
      end
    end

    def prep_for_fs_check(&block)
      stop_processes!
      in_current_dir{ block.call }
    end

    def _mkdir(dir_name)
      FileUtils.mkdir_p(dir_name) unless File.directory?(dir_name)
    end

    def unescape(string)
      string.gsub('\n', "\n").gsub('\"', '"')
    end

    def regexp(string_or_regexp)
      Regexp === string_or_regexp ? string_or_regexp : Regexp.compile(Regexp.escape(string_or_regexp))
    end

    def output_from(cmd)
      cmd = detect_ruby(cmd)
      processes[cmd].output
    end

    def stdout_from(cmd)
      cmd = detect_ruby(cmd)
      processes[cmd].stdout
    end

    def stderr_from(cmd)
      cmd = detect_ruby(cmd)
      processes[cmd].stderr
    end

    def all_stdout
      processes.values.inject("") { |out, ps| out << ps.stdout }
    end

    def all_stderr
      processes.values.inject("") { |out, ps| out << ps.stderr }
    end

    def all_output
      all_stdout << all_stderr
    end

    def assert_exact_output(exact_output)
      all_output.should == exact_output
    end

    def assert_partial_output(partial_output)
      all_output.should include(unescape(partial_output))
    end

    def assert_passing_with(partial_output)
      assert_exit_status_and_partial_output(true, partial_output)
    end

    def assert_failing_with(partial_output)
      assert_exit_status_and_partial_output(false, partial_output)
    end

    def assert_exit_status_and_partial_output(expect_to_pass, partial_output)
      assert_partial_output(partial_output)
      assert_exiting_with(expect_to_pass)
    end

    def assert_exit_status_and_output(expect_to_pass, output, expect_exact_output)
      if expect_exact_output
        assert_exact_output(output)
      else
        assert_partial_output(output)
      end
      assert_exiting_with(expect_to_pass)
    end

    def assert_exiting_with(expect_to_pass)
      if expect_to_pass
        @last_exit_status.should == 0
      else
        @last_exit_status.should_not == 0
      end
    end
    
    def processes
      @processes ||= {}
    end

    def stop_processes!
      processes.each do |_, process|
        process.stop
      end
    end

    def run(cmd)
      cmd = detect_ruby(cmd)

      in_current_dir do
        announce_or_puts("$ cd #{Dir.pwd}") if @announce_dir
        announce_or_puts("$ #{cmd}") if @announce_cmd
        
        process = processes[cmd] = Process.new(cmd, exit_timeout, io_wait)
        process.run!

        block_given? ? yield(process) : process
      end
    end

    DEFAULT_TIMEOUT_SECONDS = 1

    def exit_timeout
      @aruba_timeout_seconds || DEFAULT_TIMEOUT_SECONDS
    end

    DEFAULT_IO_WAIT_SECONDS = 0.1

    def io_wait
      @aruba_io_wait_seconds || DEFAULT_IO_WAIT_SECONDS
    end

    def run_simple(cmd, fail_on_error=true)
      @last_exit_status = run(cmd) do |process|
        process.stop
        announce_or_puts(process.stdout) if @announce_stdout
        announce_or_puts(process.stderr) if @announce_stderr
        # need to replace with process.exit_code or similar, or remove the block entirely... it doesn't add as much as I thought it would
        process.stop       
      end
      @timed_out = @last_exit_status.nil?

      if(@last_exit_status != 0 && fail_on_error)
        fail("Exit status was #{@last_exit_status}. Output:\n#{all_output}")
      end
    end

    def run_interactive(cmd)
      @interactive = run(cmd)
    end

    def type(input)
      _write_interactive(_ensure_newline(input))
    end

    def _write_interactive(input)
      @interactive.stdin.write(input)
    end

    def _ensure_newline(str)
      str.chomp << "\n"
    end

    def announce_or_puts(msg)
      if(@puts)
        puts(msg)
      else
        announce(msg)
      end
    end

    def detect_ruby(cmd)
      if cmd =~ /^ruby\s/
        cmd.gsub(/^ruby\s/, "#{current_ruby} ")
      else
        cmd
      end
    end

    def current_ruby
      File.join(RbConfig::CONFIG['bindir'], RbConfig::CONFIG['ruby_install_name'])
    end

    def use_clean_gemset(gemset)
      run_simple(%{rvm gemset create "#{gemset}"}, true)
      if all_stdout =~ /'#{gemset}' gemset created \((.*)\)\./
        gem_home = $1
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

    def unset_bundler_env_vars
      %w[RUBYOPT BUNDLE_PATH BUNDLE_BIN_PATH BUNDLE_GEMFILE].each do |key|
        set_env(key, nil)
      end
    end

    def set_env(key, value)
      announce_or_puts(%{$ export #{key}="#{value}"}) if @announce_env
      original_env[key] = ENV.delete(key)
      ENV[key] = value
    end

    def restore_env
      original_env.each do |key, value|
        ENV[key] = value
      end
    end
    
    def original_env
      @original_env ||= {}
    end
  end
end
