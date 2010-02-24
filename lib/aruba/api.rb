require 'tempfile'

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

  def run(command, world=nil, announce=nil)
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
end
end
