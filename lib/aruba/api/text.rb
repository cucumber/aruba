# Aruba
module Aruba
  # Api
  module Api
    # Text manipulation
    module Text
      # Unescape text
      #
      # '\n' => "\n"
      # '\e' => "\e"
      # '\033' => "\e"
      # '\"' => '"'
      #
      # @param [#to_s] text
      #   Input
      def unescape_text(text)
        text.gsub('\n', "\n").gsub('\"', '"').gsub('\e', "\e").gsub('\033', "\e").gsub('\016', "\016").gsub('\017', "\017").gsub('\t', "\t")
      end

      # Remove ansi characters from text
      #
      # @param [#to_s] text
      #   Input
      def extract_text(text)
        if Aruba::VERSION < '1'
          text.gsub(/(?:\e|\033)\[\d+(?>(;\d+)*)m/, '')
        else
          text.gsub(/(?:\e|\033)\[\d+(?>(;\d+)*)m/, '').gsub(/\\\[|\\\]/, '').gsub(/\007|\016|\017/, '')
        end
      end

      # Unescape special characters and remove ANSI characters
      #
      # @param [#to_s] text
      #   The text to sanitize
      def sanitize_text(text)
        text = unescape_text(text)
        text = extract_text(text) if !aruba.config.keep_ansi || aruba.config.remove_ansi_escape_sequences

        text.chomp
      end

      # @experimental
      #
      # Replace variables in command string
      #
      # @param [#to_s] text
      #   The text to parse
      def replace_variables(text)
        text = text.gsub(/<pid-last-command-started>/, last_command_started.pid.to_s) if text.include? '<pid-last-command-started>'

        text
      end
    end
  end
end
