module Aruba
  # Announcer
  #
  # @example Activate your you own channel in cucumber
  #
  #   Before('@announce-my-channel') do
  #     announcer.activate :my_channel
  #   end
  #
  # @example Activate your you own channel in rspec > 3
  #
  #   before do
  #     current_example = context.example
  #     announcer.activate :my_channel if current_example.metadata[:announce_my_channel]
  #   end
  #
  #   Aruba.announcer.announce(:my_channel, 'my message')
  #
  class Announcer
    # Dev null
    class NullAnnouncer
      def announce(*)
        nil
      end

      def mode?(*)
        true
      end
    end

    # Announcer using Kernel.puts
    class KernelPutsAnnouncer
      def announce(message)
        Kernel.puts message
      end

      def mode?(m)
        :kernel_puts == m
      end
    end

    # Announcer using Main#puts
    class PutsAnnouncer
      def announce(message)
        Kernel.puts message
      end

      def mode?(m)
        :puts == m
      end
    end

    private

    attr_reader :announcers, :default_announcer, :announcer, :channels, :format_strings

    public

    def initialize(_, options)
      @announcers = []
      @announcers << PutsAnnouncer.new
      @announcers << KernelPutsAnnouncer.new
      @announcers << NullAnnouncer.new

      @default_announcer = @announcers.last
      @announcer         = @announcers.first
      @channels          = {}
      @format_strings    = {}

      @options           = options

      after_init
    end

    # rubocop:disable Metrics/MethodLength
    def after_init
      format_string :directory, '$ cd %s'
      format_string :command, '$ %s'
      format_string :environment, '$ export %s=%s"'
      format_string :timeout, '# %s-timeout: %s seconds'

      # rubocop:disable Metrics/LineLength
      if @options[:stdout]
        warn('The use of "@announce_stdout-instance" variable and "options[:stdout] = true" for Announcer.new is deprecated. Please use "announcer.activate(:stdout)" instead.')
        activate :stdout
      end
      if @options[:stderr]
        warn('The use of "@announce_stderr-instance" variable and "options[:stderr] = true" for Announcer.new is deprecated. Please use "announcer.activate(:stderr)" instead.')
        activate :stderr
      end
      if @options[:dir]
        warn('The use of "@announce_dir-instance" variable and "options[:dir] = true" for Announcer.new is deprecated. Please use "announcer.activate(:directory)" instead.')
        activate :directory
      end
      if @options[:cmd]
        warn('The use of "@announce_cmd-instance" variable and "options[:cmd] = true" for Announcer.new is deprecated. Please use "announcer.activate(:command)" instead.')
        activate :command
      end
      if @options[:env]
        warn('The use of "@announce_env-instance" variable and "options[:env] = true" for Announcer.new is deprecated. Please use "announcer.activate(:environment)" instead.')
        activate :enviroment
      end
      # rubocop:enable Metrics/LineLength
    end
    # rubocop:enable Metrics/MethodLength

    def reset
      @default_announcer = @announcers.last
      @announcer         = @announcers.first
    end

    def format_string(channel, string)
      format_strings[channel] = string

      self
    end

    def mode=(m)
      @announcer = @announcers.find { |a| f.mode? m }

      self
    end

    def activate(channel)
      channels[channel] = true

      self
    end

    def announce(channel, *args)
      message = format(format_strings.fetch(channel, '%s'), *args)
      announcer.announce(message) if @channels[channel]

      default_announcer.announce message
    end

    def stdout(content)
      warn('The announcer now has a new api to activate channels. Please use this one: announce(:stdout, message)')
      announce :stdout, content
    end

    def stderr(content)
      warn('The announcer now has a new api to activate channels. Please use this one: announce(:stderr, message)')
      announce :stderr, content
    end

    def dir(dir)
      warn('The announcer now has a new api to activate channels. Please use this one announce(:directory, message)')
      announce :directory, dir
    end

    def cmd(cmd)
      warn('The announcer now has a new api to activate channels. Please use this one announce(:command, message)')
      announce :command, cmd
    end

    def env(key, value)
      warn('The announcer now has a new api to activate channels. Please use this one: announce(:environment, key, value)')
      announce :environment, key, value
    end
  end
end
