# frozen_string_literal: true

module Aruba
  module Matchers
    module Base
      # Provide #indent_multiline_message helper method.
      #
      # @api private
      module MessageIndenter
        module_function

        def indent_multiline_message(message)
          message = message.sub(/\n+\z/, '')
          message.lines.map do |line|
            /\S/.match?(line) ? "   #{line}" : line
          end.join
        end
      end
    end
  end
end
