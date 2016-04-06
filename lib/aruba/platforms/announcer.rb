require 'shellwords'
require 'aruba/colorizer'

Aruba::AnsiColor.coloring = false if !STDOUT.tty? && !ENV.key?("AUTOTEST")

# Aruba
module Aruba
  # Platforms
  module Platforms
    # Announcer
    #
    # @private
    #
    # @example Activate your you own channel in cucumber
    #
    #   Before('@announce-my-channel') do
    #     aruba.announcer.activate :my_channel
    #   end
    #
    # @example Activate your you own channel in rspec > 3
    #
    #   before do
    #     current_example = context.example
    #     aruba.announcer.activate :my_channel if current_example.metadata[:announce_my_channel]
    #   end
    #
    #   Aruba.announcer.announce(:my_channel, 'my message')
    #
    class Announcer
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
          puts message
        end

        def mode?(m)
          :puts == m
        end
      end

      private

      attr_reader :announcers, :announcer, :channels, :output_formats, :colorizer

      public

      def initialize(*args)
        @announcers = []
        @announcers << PutsAnnouncer.new
        @announcers << KernelPutsAnnouncer.new

        @colorizer = Aruba::Colorizer.new

        @announcer         = @announcers.first
        @channels          = {}
        @output_formats    = {}

        @options           = args[1] || {}

        after_init
      end

      private

      # rubocop:disable Metrics/MethodLength
      def after_init
        output_format :changed_configuration, proc { |n, v| format('# %s = %s', n, v) }
        output_format :changed_environment, proc { |n, v| format('$ export %s=%s', n, Shellwords.escape(v)) }
        output_format :command, '$ %s'
        output_format :directory, '$ cd %s'
        output_format :environment, proc { |n, v| format('$ export %s=%s', n, Shellwords.escape(v)) }
        output_format :full_environment, proc { |h| format("<<-ENVIRONMENT\n%s\nENVIRONMENT", Aruba.platform.simple_table(h)) }
        output_format :modified_environment, proc { |n, v| format('$ export %s=%s', n, Shellwords.escape(v)) }
        output_format :stderr, "<<-STDERR\n%s\nSTDERR"
        output_format :stdout, "<<-STDOUT\n%s\nSTDOUT"
        output_format :command_content, "<<-COMMAND\n%s\nCOMMAND"
        output_format :stop_signal, proc { |p, s| format('Command will be stopped with `kill -%s %s`', s, p) }
        output_format :timeout, '# %s-timeout: %s seconds'
        output_format :wait_time, '# %s: %s seconds'
        # rubocop:disable Metrics/LineLength
        output_format :command_filesystem_status, proc { |status| format("<<-COMMAND FILESYSTEM STATUS\n%s\nCOMMAND FILESYSTEM STATUS", Aruba.platform.simple_table(status.to_h, :sort => false)) }
        # rubocop:enable Metrics/LineLength
      end
      # rubocop:enable Metrics/MethodLength

      def output_format(channel, string = '%s', &block)
        output_formats[channel.to_sym] = if block_given?
                                           block
                                         elsif string.is_a?(Proc)
                                           string
                                         else
                                           proc { |*args| format(string, *args) }
                                         end
      end

      public

      # Reset announcer
      def reset
        @announcer = @announcers.first
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
      def activate(*chns)
        chns.flatten.each { |c| channels[c.to_sym] = true }

        self
      end

      # Deactivates a channel
      #
      # @param [Symbol] channel
      #   The name of the channel to activate
      def deactivate(*chns)
        chns.flatten.each { |c| channels[c.to_sym] = false }
        self
      end

      # Announce information to channel
      #
      # @param [Symbol] channel
      #   The name of the channel to check
      #
      # @param [Array] args
      #   Arguments
      #
      # @yield
      #   If block is given, that one is called and the return value is used as
      #   message to be announced.
      def announce(channel, *args, &block)
        channel = channel.to_sym

        the_output_format = if output_formats.key? channel
                              output_formats[channel]
                            else
                              proc { |v| format('%s', v) }
                            end

        return unless activated?(channel)

        message = if block_given?
                    the_output_format.call(yield)
                  else
                    the_output_format.call(*args)
                  end
        message += "\n"
        message = colorizer.cyan(message)

        announcer.announce(message)

        nil
      end
    end
  end
end
