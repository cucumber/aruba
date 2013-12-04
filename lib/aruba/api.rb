require 'fileutils'
require 'rbconfig'
require 'rspec/expectations'
require 'aruba'
require 'aruba/config'

Dir.glob( File.join( File.expand_path( '../matchers' , __FILE__ )  , '*.rb' ) ).each { |rb| require rb }

module Aruba
  module Api
    include RSpec::Matchers

    def in_current_dir(&block)
      _mkdir(current_dir)
      Dir.chdir(current_dir, &block)
    end

    def clean_current_dir
      _rm_rf(current_dir)
      _mkdir(current_dir)
    end

    def current_dir
      File.join(*dirs)
    end

    def cd(dir)
      dirs << dir
      raise "#{current_dir} is not a directory." unless File.directory?(current_dir)
    end

    def dirs
      @dirs ||= ['tmp', 'aruba']
    end

    def write_file(file_name, file_content)
      _create_file(file_name, file_content, false)
    end

    def write_fixed_size_file(file_name, file_size)
      _create_fixed_size_file(file_name, file_size, false)
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

    def chmod(mode, name)
      in_current_dir do
        raise "expected #{name} to be present" unless FileTest.exists?(name)
        if mode.kind_of? String
          FileUtils.chmod(mode.to_i(8),name)
        else
          FileUtils.chmod(mode,name)
        end
      end
    end

    def mod?(mode, name)
      in_current_dir do
        mode == sprintf( "%o", File::Stat.new(name).mode )[-4,4].to_i(8)
      end
    end

    def _create_fixed_size_file(file_name, file_size, check_presence)
      in_current_dir do
        raise "expected #{file_name} to be present" if check_presence && !File.file?(file_name)
        _mkdir(File.dirname(file_name))
        File.open(file_name, "wb"){ |f| f.seek(file_size - 1); f.write("\0") }
      end
    end

    def remove_file(file_name)
      in_current_dir do
        FileUtils.rm(file_name)
      end
    end

    def append_to_file(file_name, file_content)
      in_current_dir do
        _mkdir(File.dirname(file_name))
        File.open(file_name, 'a') { |f| f << file_content }
      end
    end

    def create_dir(dir_name)
      in_current_dir do
        _mkdir(dir_name)
      end
    end

    def remove_dir(directory_name)
      in_current_dir do
        FileUtils.rmdir(directory_name)
      end
    end

    def check_file_presence(paths, expect_presence)
      prep_for_fs_check do
        paths.each do |path|
          if path.kind_of? Regexp
            if expect_presence
              expect(Dir.glob('**/*')).to include_regexp(path)
            else
              expect(Dir.glob('**/*')).not_to include_regexp(path)
            end
          else
            if expect_presence
              expect(File).to be_file(path)
            else
              expect(File).not_to be_file(path)
            end
          end
        end
      end
    end

    def pipe_in_file(file)
      in_current_dir do
        File.open(file, 'r').each_line do |line|
          _write_interactive(line)
        end
      end
    end

    def check_file_size(paths_and_sizes)
      prep_for_fs_check do
        paths_and_sizes.each do |path, size|
          expect(File.size(path)).to eq size
        end
      end
    end

    def with_file_content(file, &block)
      prep_for_fs_check do
        content = IO.read(file)
        yield(content)
      end
    end

    def check_file_content(file, partial_content, expect_match)
      regexp = regexp(partial_content)
      prep_for_fs_check do
        content = IO.read(file)
        if expect_match
          expect(content).to match regexp
        else
          expect(content).not_to match regexp
        end
      end
    end

    def check_exact_file_content(file, exact_content)
      prep_for_fs_check { expect(IO.read(file)).to eq exact_content }
    end

    def check_directory_presence(paths, expect_presence)
      prep_for_fs_check do
        paths.each do |path|
          if expect_presence
            expect(File).to be_directory(path)
          else
            expect(File).not_to be_directory(path)
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

    def _rm_rf(dir_name)
      FileUtils.rm_rf(dir_name)
    end

    def unescape(string)
      string = string.gsub('\n', "\n").gsub('\"', '"').gsub('\e', "\e")
      string = string.gsub(/\e\[\d+(?>(;\d+)*)m/, '') unless @aruba_keep_ansi
      string
    end

    def regexp(string_or_regexp)
      Regexp === string_or_regexp ? string_or_regexp : Regexp.compile(Regexp.escape(string_or_regexp))
    end

    def output_from(cmd)
      cmd = detect_ruby(cmd)
      get_process(cmd).output
    end

    def stdout_from(cmd)
      cmd = detect_ruby(cmd)
      get_process(cmd).stdout
    end

    def stderr_from(cmd)
      cmd = detect_ruby(cmd)
      get_process(cmd).stderr
    end

    def all_stdout
      stop_processes!
      only_processes.inject("") { |out, ps| out << ps.stdout }
    end

    def all_stderr
      stop_processes!
      only_processes.inject("") { |out, ps| out << ps.stderr }
    end

    def all_output
      all_stdout << all_stderr
    end

    def assert_exact_output(expected, actual)
      actual.force_encoding(expected.encoding) if RUBY_VERSION >= "1.9"
      expect(unescape(actual)).to eq unescape(expected)
    end

    def assert_partial_output(expected, actual)
      actual.force_encoding(expected.encoding) if RUBY_VERSION >= "1.9"
      expect(unescape(actual)).to include(unescape(expected))
    end

    def assert_matching_output(expected, actual)
      actual.force_encoding(expected.encoding) if RUBY_VERSION >= "1.9"
      expect(unescape(actual)).to match /#{unescape(expected)}/m
    end

    def assert_not_matching_output(expected, actual)
      actual.force_encoding(expected.encoding) if RUBY_VERSION >= "1.9"
      expect(unescape(actual)).not_to match /#{unescape(expected)}/m
    end

    def assert_no_partial_output(unexpected, actual)
      actual.force_encoding(unexpected.encoding) if RUBY_VERSION >= "1.9"
      if Regexp === unexpected
        expect(unescape(actual)).not_to match unexpected
      else
        expect(unescape(actual)).not_to include(unexpected)
      end
    end

    def assert_partial_output_interactive(expected)
      unescape(_read_interactive).include?(unescape(expected)) ? true : false
    end

    def assert_passing_with(expected)
      assert_exit_status_and_partial_output(true, expected)
    end

    def assert_failing_with(expected)
      assert_exit_status_and_partial_output(false, expected)
    end

    def assert_exit_status_and_partial_output(expect_to_pass, expected)
      assert_success(expect_to_pass)
      assert_partial_output(expected, all_output)
    end

    # TODO: Remove this. Call more methods elsewhere instead. Reveals more intent.
    def assert_exit_status_and_output(expect_to_pass, expected_output, expect_exact_output)
      assert_success(expect_to_pass)
      if expect_exact_output
        assert_exact_output(expected_output, all_output)
      else
        assert_partial_output(expected_output, all_output)
      end
    end

    def assert_success(success)
      success ? assert_exit_status(0) : assert_not_exit_status(0)
    end

    def assert_exit_status(status)
      expect(last_exit_status).to eq(status),
        append_output_to("Exit status was #{last_exit_status} but expected it to be #{status}.")
    end

    def assert_not_exit_status(status)
      expect(last_exit_status).not_to eq(status),
        append_output_to("Exit status was #{last_exit_status} which was not expected.")
    end

    def append_output_to(message)
      "#{message} Output:\n\n#{all_output}\n"
    end

    def processes
      @processes ||= []
    end

    def stop_processes!
      processes.each do |_, process|
        stop_process(process)
      end
    end

    def terminate_processes!
      processes.each do |_, process|
        terminate_process(process)
        stop_process(process)
      end
    end

    def register_process(name, process)
      processes << [name, process]
    end

    def get_process(wanted)
      matching_processes = processes.reverse.find{ |name, _| name == wanted }
      raise ArgumentError.new("No process named '#{wanted}' has been started") unless matching_processes
      matching_processes.last
    end

    def only_processes
      processes.collect{ |_, process| process }
    end

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

    def exit_timeout
      @aruba_timeout_seconds || DEFAULT_TIMEOUT_SECONDS
    end

    DEFAULT_IO_WAIT_SECONDS = 0.1

    def io_wait
      @aruba_io_wait_seconds || DEFAULT_IO_WAIT_SECONDS
    end

    def run_simple(cmd, fail_on_error=true, timeout = nil)
      run(cmd, timeout) do |process|
        stop_process(process)
      end
      @timed_out = last_exit_status.nil?
      assert_exit_status(0) if fail_on_error
    end

    def run_interactive(cmd)
      @interactive = run(cmd)
    end

    def type(input)
      return close_input if "" == input
      _write_interactive(_ensure_newline(input))
    end

    def close_input
      @interactive.stdin.close
    end

    def eot
      warn(%{\e[35m    The \"#eot\"-method is deprecated. It will be deleted with the next major version. Please use \"#close_input\"-method instead.\e[0m})
      close_input
    end

    def _write_interactive(input)
      @interactive.stdin.write(input)
      @interactive.stdin.flush
    end

    def _read_interactive
      @interactive.read_stdout
    end

    def _ensure_newline(str)
      str.chomp << "\n"
    end

    def announce_or_puts(msg)
      if(@puts)
        Kernel.puts(msg)
      else
        puts(msg)
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
      announcer.env(key, value)
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
