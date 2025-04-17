# frozen_string_literal: true

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
    # @param [Hash] opts
    #   Options
    #
    # @option opts [Symbol] :default_mode Log level
    def initialize(opts = {})
      @mode = opts.fetch(:default_mode, :info)
    end

    # @!method fatal(msg)
    # Log a fatal level log message

    # @!method warn(msg)
    # Log a warn level log message

    # @!method debug(msg)
    # Log a debug level log message

    # @!method info(msg)
    # Log an info level log message

    # @!method error(msg)
    # Log an error level log message

    # @!method unknown(msg)
    # Log an unknown level log message

    %i[fatal warn debug info error unknown].each do |m|
      define_method m do |msg|
        logger.public_send m, msg
      end
    end

    # Create new logger on every invocation to make
    # capturing $stderr possible
    def logger
      l = ::Logger.new($stderr)

      if mode == :debug
        format_debug(l)
      else
        format_standard(l)
      end

      l.level = case mode
                when :debug
                  ::Logger::DEBUG
                when :silent
                  9_999
                else
                  ::Logger::INFO
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
