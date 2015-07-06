require 'rspec/core'

require 'aruba'
require 'aruba/api'

RSpec.configure do |config|
  config.include Aruba::Api, :type => :aruba

  config.before :each do
    next unless self.class.include? Aruba::Api

    restore_env
    setup_aruba
  end

  # Activate on 1.0.0
  # config.around :each do |example|
  #   old_env = ENV.to_hash
  #   example.run
  #   ENV.update old_env
  # end

  config.around :each do |example|
    project_bin = Aruba::ArubaPath.new(Aruba.config.root_directory)
    project_bin << 'bin'

    old_path    = ENV.fetch 'PATH', ''

    paths = old_path.split(File::PATH_SEPARATOR)
    paths.unshift project_bin

    ENV['PATH'] = paths.join(File::PATH_SEPARATOR)

    example.run

    ENV['PATH'] = old_path
  end

  config.before :each do |example|
    next unless self.class.include? Aruba::Api

    example.metadata.each { |k, v| aruba.config.set_if_option(k, v) }
  end

  config.before :each do |example|
    next unless self.class.include?(Aruba::Api)

    announcer.activate(:environment) if example.metadata[:announce_environment]
    announcer.activate(:command)     if example.metadata[:announce_command]
    announcer.activate(:directory)   if example.metadata[:announce_directory]
    announcer.activate(:stdout)      if example.metadata[:announce_stdout]
    announcer.activate(:stderr)      if example.metadata[:announce_stderr]

    if example.metadata[:announce_output]
      announcer.activate(:stderr)
      announcer.activate(:stdout)
    end

    if example.metadata[:announce]
      announcer.activate(:stderr)
      announcer.activate(:stdout)
      announcer.activate(:environment)
      announcer.activate(:command)
      announcer.activate(:directory)
    end
  end

  config.before :each do
    next unless self.class.include? Aruba::Api

    aruba.environment.update aruba.config.command_runtime_environment
    aruba.environment.prepend 'PATH', aruba.config.command_search_paths.join(':') + ':'
  end
end
