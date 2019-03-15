require 'aruba/matchers/base/message_indenter'

# @!method have_output
#   This matchers checks if <command> has created output
#
#   @return [Boolean] The result
#
#     false:
#     * if command has not created output
#     true:
#     * if command created output
#
#   @example Use matcher
#
#     RSpec.describe do
#       it { expect(last_command_started).to have_output }
#     end
RSpec::Matchers.define :have_output do |expected|
  match do |actual|
    @old_actual = actual

    next false unless @old_actual.respond_to? :output

    @old_actual.stop

    @actual = sanitize_text(actual.output)

    values_match?(expected || /./, @actual)
  end

  diffable

  description do
    if expected
      "have output: #{description_of expected}"
    else
      "have output"
    end
  end

  failure_message do
    if expected
      "expected `#{@old_actual.commandline}` to have output #{description_of expected}\n" \
        "but was:\n#{Aruba::Matchers::Base::MessageIndenter.indent_multiline_message @actual}"
    else
      "expected `#{@old_actual.commandline}` to have output"
    end
  end
end

RSpec::Matchers.alias_matcher :a_command_having_output, :have_output
