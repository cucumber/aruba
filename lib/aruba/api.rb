require 'tempfile'
require 'rbconfig'

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

  def create_file(file_name, file_content)
    in_current_dir do
      _mkdir(File.dirname(file_name))
      File.open(file_name, 'w') { |f| f << file_content }
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
    in_current_dir do
      paths.each do |path|
        if expect_presence
          File.should be_file(path)
        else
          File.should_not be_file(path)
        end
      end
    end
  end

  def _mkdir(dir_name)
    FileUtils.mkdir_p(dir_name) unless File.directory?(dir_name)
  end

  def unescape(string)
    eval(%{"#{string}"})
  end

  def compile_and_escape(string)
    Regexp.compile(Regexp.escape(string))
  end

  def combined_output
    @last_stdout + (@last_stderr == '' ? '' : "\n#{'-'*70}\n#{@last_stderr}")
  end

  def use_rvm(rvm_ruby_version)
    if File.exist?('config/aruba-rvm.yml')
      @rvm_ruby_version = YAML.load_file('config/aruba-rvm.yml')[rvm_ruby_version] || rvm_ruby_version
    else
      @rvm_ruby_version = rvm_ruby_version
    end
  end

  def use_rvm_gemset(rvm_gemset)
    @rvm_gemset = rvm_gemset
  end

  def run(command, world=nil, announce=nil)
    command = detect_ruby(command)

    if(announce)
      world ? world.announce(command) : STDOUT.puts(command)
    end

    stderr_file = Tempfile.new('cucumber')
    stderr_file.close
    in_current_dir do
      mode = RUBY_VERSION =~ /^1\.9/ ? {:external_encoding=>"UTF-8"} : 'r'
      IO.popen("#{command} 2> #{stderr_file.path}", mode) do |io|
        @last_stdout = io.read
      end

      @last_exit_status = $?.exitstatus
    end
    @last_stderr = IO.read(stderr_file.path)
  end

  RUBY_PATTERN = /^ruby\s/
  RUBY_SCRIPTS_PATTERN = /^(?:gem|rake)\s/

  def detect_ruby(command)
    ruby_command = command =~ RUBY_PATTERN
    ruby_script  = command =~ RUBY_SCRIPTS_PATTERN
    if ruby_command || ruby_script
      if @rvm_ruby_version
        rvm_ruby_version_with_gemset = @rvm_gemset ? "#{@rvm_ruby_version}%#{@rvm_gemset}" : @rvm_ruby_version
        command = "rvm #{rvm_ruby_version_with_gemset} #{command}"
      elsif ruby_command
        command.gsub(/^ruby\s/, "#{File.join(Config::CONFIG['bindir'], Config::CONFIG['ruby_install_name'])} ")
      else
        "#{File.join(Config::CONFIG['bindir'], Config::CONFIG['ruby_install_name'])} -S #{command}"
      end
    else
      command
    end
  end
end
end
