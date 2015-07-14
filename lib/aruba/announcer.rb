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

    attr_reader :announcers, :default_announcer, :announcer, :channels, :output_formats

    public

    def initialize(_, options)
      @announcers = []
      @announcers << PutsAnnouncer.new
      @announcers << KernelPutsAnnouncer.new
      @announcers << NullAnnouncer.new

      @default_announcer = @announcers.last
      @announcer         = @announcers.first
      @channels          = {}
      @output_formats    = {}

      @options           = options

      after_init
    end

    private

    # rubocop:disable Metrics/MethodLength
    def after_init
      output_format :directory, '$ cd %s'
      output_format :command, '$ %s'
      output_format :environment, '$ export %s=%s"'
      output_format :modified_environment, '$ export %s=%s"'
      output_format :full_environment, proc { |h| environment_table(h) }
      output_format :timeout, '# %s-timeout: %s seconds'

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
        warn('The use of "@announce_env-instance" variable and "options[:env] = true" for Announcer.new is deprecated. Please use "announcer.activate(:modified_environment)" instead.')
        activate :modified_enviroment
      end
      # rubocop:enable Metrics/LineLength
    end
    # rubocop:enable Metrics/MethodLength

    def output_format(channel, string = '%s', &block)
      if block_given?
        output_formats[channel.to_sym] = block
      elsif  string.is_a?(Proc)
        output_formats[channel.to_sym] = string
      else
        output_formats[channel.to_sym] = proc { |*args| format(string, *args) }
      end

      self
    end

    def environment_table(h)
      name_size = h.keys.max_by(&:length).length
      value_size = h.values.max_by(&:length).length

      result = []

      h.each do |k,v|
        result << format('%s => %s', k + ' ' * (name_size - k.to_s.size), v + ' ' * (value_size - v.to_s.size))
      end

      result
    end

    public

    # Reset announcer
    def reset
      @default_announcer = @announcers.last
      @announcer         = @announcers.first
    end

    # Change mode of announcer
    #
    # @param [Symbol] m
    #   The mode to set
    def mode=(m)
      @announcer = @announcers.find { |a| f.mode? m.to_sym }

      self
    end

    # Check if channel is activated
    #
    # @param [Symbol] channel
    #   The name of the channel to check
    def activated?(channel)
      channels[channel.to_sym] == true
    end

    # Activate a channel
    #
    # @param [Symbol] channel
    #   The name of the channel to activate
    def activate(channel)
      channels[channel.to_sym] = true

      self
    end

    # Announce information to channel
    #
    # @param [Symbol] channel
    #   The name of the channel to check
    #
    # @param [Array] args
    #   Arguments
    def announce(channel, *args)
      channel = channel.to_sym

      the_output_format = if output_formats.key? channel
                            output_formats[channel]
                          else
                            proc { |v| format('%s', v) }
                          end

      message = the_output_format.call(*args)

      announcer.announce(message) if channels[channel]

      default_announcer.announce message
    end

    # @deprecated
    def stdout(content)
      warn('The announcer now has a new api to activate channels. Please use this one: announce(:stdout, message)')
      announce :stdout, content
    end

    # @deprecated
    def stderr(content)
      warn('The announcer now has a new api to activate channels. Please use this one: announce(:stderr, message)')
      announce :stderr, content
    end

    # @deprecated
    def dir(dir)
      warn('The announcer now has a new api to activate channels. Please use this one announce(:directory, message)')
      announce :directory, dir
    end

    # @deprecated
    def cmd(cmd)
      warn('The announcer now has a new api to activate channels. Please use this one announce(:command, message)')
      announce :command, cmd
    end

    # @deprecated
    def env(key, value)
      warn('The announcer now has a new api to activate channels. Please use this one: announce(:modified_environment, key, value)')

      announce :modified_environment, key, value
    end
  end
end
