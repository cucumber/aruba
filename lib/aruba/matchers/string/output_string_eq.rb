# frozen_string_literal: true

# @!method output_string_eq(string)
#   This matchers checks if the output string of a command includes string.
#
#   @param [String] string
#     The value of the output string
#
#   @return [Boolean]
#
#     False:
#     * if the output string does not include string
#     True:
#     * if the output string includes string
#
#   @example Use matcher
#     RSpec.describe do
#       it { expect(last_command_started).to have_output output_string_eq string) }
#       it { expect(last_command_started).to have_output an_output_string_begin_eq string) }
#     end
RSpec::Matchers.define :output_string_eq do |expected|
  match do |actual|
    actual.force_encoding('UTF-8')
    @expected = sanitize_text(expected.to_s)
    @actual   = sanitize_text(actual.to_s)

    values_match? @expected, @actual
  end

  diffable

  description { "output string is eq: #{description_of expected}" }
end

RSpec::Matchers.alias_matcher :an_output_string_being_eq, :output_string_eq
