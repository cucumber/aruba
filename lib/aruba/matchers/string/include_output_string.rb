# @!method include_output_string(string)
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
#       it { expect(last_command_started).to have_output an_output_string_including string) }
#       it { expect(last_command_started).to have_output include_output_string string) }
#     end
RSpec::Matchers.define :include_output_string do |expected|
  match do |actual|
    @expected = Regexp.new(Regexp.escape(sanitize_text(expected.to_s)), Regexp::MULTILINE)
    @actual   = sanitize_text(actual)

    values_match? @expected, @actual
  end

  diffable

  description { "string includes: #{description_of expected}" }
end

if RSpec::Expectations::Version::STRING >= '3.0'
  RSpec::Matchers.alias_matcher :an_output_string_including, :include_output_string
  RSpec::Matchers.alias_matcher :file_content_including, :include_output_string
end
