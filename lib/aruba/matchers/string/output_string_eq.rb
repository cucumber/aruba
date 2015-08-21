# @!method output_string_eq(string)
#   This matchers checks if the output string of a command includes string.
#
#   @param [Integer] status
#     The value of the exit status
#
#   @return [TrueClass, FalseClass] The result
#
#     false:
#     * if the output string does not include string
#     true:
#     * if the output string includes string
#
#   @example Use matcher
#
#     RSpec.describe do
#       it { expect(last_command_started).to have_output output_string_eq string) }
#       it { expect(last_command_started).to have_output an_output_string_begin_eq string) }
#     end
RSpec::Matchers.define :output_string_eq do |expected|
  match do |actual|
    @expected = sanitize_text(expected.to_s)
    @actual   = sanitize_text(actual.to_s)

    values_match? @expected, @actual
  end

  diffable

  description { "output string is eq: #{description_of expected}" }
end

if RSpec::Expectations::Version::STRING >= '3.0'
  RSpec::Matchers.alias_matcher :an_output_string_being_eq, :output_string_eq
end
