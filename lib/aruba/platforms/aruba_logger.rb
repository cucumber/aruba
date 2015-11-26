require 'logger'

# Aruba
module Aruba
  # Logger
  #
  # @private
  class ArubaLogger
    attr_reader :mode

    # Create logger
    #
    # @param [Logger] logger (::Logger.new( $stderr ))
    #   The logger with should be used to output data
    def initialize(opts = {})
      @mode = opts.fetch(:default_mode, :info)
    end

    [:fatal, :warn, :debug, :info, :error, :unknown].each do |m|
      define_method m do |msg|
        if RUBY_VERSION < '1.9'
          logger.send m, msg
        else
          logger.public_send m, msg
        end
      end
    end

    # Create new logger on every invocation to make
    # capturing $stderr possible
    def logger
      l = ::Logger.new($stderr)

      case mode
      when :debug
        l.level = ::Logger::DEBUG
        format_debug(l)
      when :silent
        l.level = 9_999
      when :info
        l.level = ::Logger::INFO
        format_standard(l)
      else
        l.level = ::Logger::INFO
        format_standard(l)
      end

      l
    end

    # Is mode?
    #
    # @param [String, Symbol] m
    #   Mode to compare with
    def mode?(m)
      mode == m.to_sym
    end

    # Change mode of logger: :debug, ... + Change the output format
    #
    # @param [Symbol] m
    #   the mode: :debug, ...
    def mode=(m)
      @mode = m.to_sym
    end

    private

    def format_debug(l)
      l.formatter = proc { |severity, datetime, progname, msg|
        format("%s %s %s: %s\n", datetime, severity, progname, msg)
      }
    end

    def format_standard(l)
      l.formatter = proc { |severity, datetime, _, msg|
        format("%s %s: %s\n", datetime, severity, msg)
      }
    end
  end
end
