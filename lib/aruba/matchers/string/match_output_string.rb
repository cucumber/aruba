# @!method match_output_string(string)
#   This matchers checks if the output string of a command matches regular expression.
#
#   @param [Integer] status
#     The value of the exit status
#
#   @return [TrueClass, FalseClass] The result
#
#     false:
#     * if the output string does not match regex
#     true:
#     * if the output string matches regex
#
#   @example Use matcher
#
#     RSpec.describe do
#       it { expect(last_command_started).to have_output an_output_string_matching regex) }
#       it { expect(last_command_started).to have_output match_output_string regex) }
#     end
RSpec::Matchers.define :match_output_string do |expected|
  match do |actual|
    @expected = Regexp.new(unescape_text(expected), Regexp::MULTILINE)
    @actual   = sanitize_text(actual)

    values_match? @expected, @actual
  end

  diffable

  description { "output string matches: #{description_of expected}" }
end

if RSpec::Expectations::Version::STRING >= '3.0'
  RSpec::Matchers.alias_matcher :an_output_string_matching, :match_output_string
  RSpec::Matchers.alias_matcher :a_file_name_matching, :match_output_string
  RSpec::Matchers.alias_matcher :file_content_matching, :match_output_string
end
