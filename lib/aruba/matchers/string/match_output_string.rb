# frozen_string_literal: true

# @!method match_output_string(string)
#   This matchers checks if the output string of a command matches regular expression.
#
#   @param [String] string
#     The value of the output string
#
#   @return [Boolean] The result
#
#     False:
#     * if the output string does not match regex
#     True:
#     * if the output string matches regex
#
#   @example Use matcher
#     RSpec.describe do
#       it { expect(last_command_started).to have_output an_output_string_matching regex) }
#       it { expect(last_command_started).to have_output match_output_string regex) }
#     end
RSpec::Matchers.define :match_output_string do |expected|
  match do |actual|
    actual.force_encoding('UTF-8')
    @expected = Regexp.new(unescape_text(expected), Regexp::MULTILINE)
    @actual   = sanitize_text(actual)

    values_match? @expected, @actual
  end

  diffable

  description { "output string matches: #{description_of expected}" }
end

RSpec::Matchers.alias_matcher :an_output_string_matching, :match_output_string
RSpec::Matchers.alias_matcher :a_file_name_matching, :match_output_string
RSpec::Matchers.alias_matcher :file_content_matching, :match_output_string
