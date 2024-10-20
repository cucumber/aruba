# frozen_string_literal: true

require 'shellwords'
require 'aruba/colorizer'

Aruba::Colorizer.coloring = false if !$stdout.tty? && !ENV.key?('AUTOTEST')

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
    #     if current_example.metadata[:announce_my_channel]
    #       aruba.announcer.activate :my_channel
    #     end
    #   end
    #
    #   Aruba.announcer.announce(:my_channel, 'my message')
    #
    class Announcer
      # Base Announcer class
      class BaseAnnouncer
        def mode?(m)
          mode == m
        end
      end

      # Announcer using Kernel.puts
      class KernelPutsAnnouncer < BaseAnnouncer
        def announce(message)
          Kernel.puts message
        end

        def mode
          :kernel_puts
        end
      end

      # Announcer using Main#puts
      class PutsAnnouncer < BaseAnnouncer
        def announce(message)
          puts message
        end

        def mode
          :puts
        end
      end

      private

      attr_reader :announcers, :announcer, :channels, :output_formats, :colorizer

      public

      def initialize
        @announcers = []
        @announcers << PutsAnnouncer.new
        @announcers << KernelPutsAnnouncer.new

        @colorizer = Aruba::Colorizer.new

        @announcer         = @announcers.first
        @channels          = {}
        @output_formats    = {}

        after_init
      end

      private

      def after_init
        output_format :changed_configuration, proc { |n, v| format('# %s = %s', n, v) }
        output_format :changed_environment,
                      proc { |n, v| format('$ export %s=%s', n, Shellwords.escape(v)) }
        output_format :command, '$ %s'
        output_format :directory, '$ cd %s'
        output_format :environment,
                      proc { |n, v| format('$ export %s=%s', n, Shellwords.escape(v)) }
        output_format :full_environment,
                      proc { |h|
                        format("<<-ENVIRONMENT\n%s\nENVIRONMENT",
                               Aruba.platform.simple_table(h))
                      }
        output_format :modified_environment,
                      proc { |n, v| format('$ export %s=%s', n, Shellwords.escape(v)) }
        output_format :stderr, "<<-STDERR\n%s\nSTDERR"
        output_format :stdout, "<<-STDOUT\n%s\nSTDOUT"
        output_format :command_content, "<<-COMMAND\n%s\nCOMMAND"
        output_format :stop_signal,
                      proc { |p, s|
                        format('Command will be stopped with `kill -%s %s`', s, p)
                      }
        output_format :timeout, '# %s-timeout: %s seconds'
        output_format :wait_time, '# %s: %s seconds'
        output_format :command_filesystem_status,
                      proc { |status|
                        format("<<-COMMAND FILESYSTEM STATUS\n%s\nCOMMAND FILESYSTEM STATUS",
                               Aruba.platform.simple_table(status.to_h, sort: false))
                      }
      end

      def output_format(channel, string = '%s', &block)
        output_formats[channel.to_sym] = if block
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
        @announcer = @announcers.find { |a| a.mode? m.to_sym }
      end

      # Fecth mode of announcer
      #
      # @return [Symbol] The current announcer mode
      def mode
        @announcer.mode
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
      # @param [Symbol] chns
      #   The name of the channel to activate
      def activate(*chns)
        chns.flatten.each { |c| channels[c.to_sym] = true }

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
      def announce(channel, *args)
        channel = channel.to_sym

        the_output_format = if output_formats.key? channel
                              output_formats[channel]
                            else
                              proc { |v| format('%s', v) }
                            end

        return unless activated?(channel)

        begin
          if block_given?
            value = yield
            args << value
          end

          message = the_output_format.call(*args)
          message += "\n"
          message = colorizer.cyan(message)
        rescue NotImplementedError => e
          message = "Error fetching announced value for #{channel}: #{e.message}"
        end

        announcer.announce(message)

        nil
      end
    end
  end
end
