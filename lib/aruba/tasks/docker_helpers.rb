require 'psych'

module Aruba
  class DockerRunInstance
    protected

    attr_reader :file, :instance

    public

    def initialize(file, instance)
      @file     = file
      @instance = instance
    end

    def method_missing(m, *_args)
      return @file.public_send m, instance if @file.respond_to?(m)

      super
    end

    def respond_to_missing?(m)
      @file.respond_to? m
    end
  end

  class DockerBuildCommandLineBuilder
    protected

    attr_reader :run_instance, :opts

    public

    def initialize(run_instance, opts = {})
      @run_instance = run_instance
      @opts = opts
    end

    def to_cli
      cache               = opts[:cache]
      application_version = opts[:version]
      docker_file         = run_instance.docker_file
      docker_image        = run_instance.image

      cmdline = []
      cmdline << 'docker'
      cmdline << 'build'
      cmdline << '--no-cache=true' if cache == 'false'

      %w(http_proxy https_proxy HTTP_PROXY HTTPS_PROXY).each do |var|
        next unless ENV.key? var

        proxy_uri = URI(ENV[var])
        proxy_uri.host = '172.17.0.1'
        cmdline << "--build-arg #{var}=#{proxy_uri}"
      end

      cmdline << "-t #{docker_image}:#{application_version}"
      cmdline << "-f #{docker_file}"
      cmdline << File.dirname(docker_file)

      cmdline.join(' ')
    end
  end

  class DockerRunCommandLineBuilder
    protected

    attr_reader :run_instance, :opts

    public

    def initialize(run_instance, opts = {})
      @run_instance = run_instance
      @opts         = opts
    end

    def to_cli
      volumes = run_instance.volumes
      image   = run_instance.image
      command = opts[:command]

      cmdline = []
      cmdline << 'docker'
      cmdline << 'run'
      cmdline << '-it'
      cmdline << '--rm'
      cmdline << "--name #{run_instance.container_name}"

      volumes.each do |v|
        cmdline << "-v #{expand_volume_paths(v)}"
      end

      cmdline << image
      cmdline << command if command

      cmdline.join(' ')
    end

    private

    def expand_volume_paths(volume_paths)
      volume_paths.split(':').map { |path| File.expand_path(path) }.join(':')
    end
  end

  class DockerComposeFile
    protected

    attr_reader :data

    public

    def initialize(path)
      @data = Psych.load_file(path)['services']
    end

    def volumes(instance)
      fetch(instance)['volumes']
    end

    def build_context(instance)
      fetch(instance).fetch('build', {})['context']
    end

    def build_arguments(instance)
      fetch(instance).fetch('build', {})['args']
    end

    def docker_file(instance)
      fetch(instance).fetch('build', {})['dockerfile']
    end

    def image(instance)
      fetch(instance)['image']
    end

    def container_name(instance)
      fetch(instance)['container_name']
    end

    def command(instance)
      fetch(instance)['command']
    end

    def working_directory(instance)
      fetch(instance)['working_dir']
    end

    private

    def fetch(instance)
      Hash(data).fetch(instance.to_s)
    end
  end
end
