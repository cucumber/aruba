# @!method have_output
#   This matchers checks if <command> has created output
#
#   @return [TrueClass, FalseClass] The result
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
    next false unless actual.respond_to? :output

    @old_actual = actual
    @actual = Aruba::Platform.unescape(actual.output.chomp, aruba.config.keep_ansi)

    values_match?(expected, @actual)
  end

  diffable

  description { "have output: #{description_of expected}" }
end

if RSpec::Expectations::Version::STRING >= '3.0'
  RSpec::Matchers.alias_matcher :a_command_having_output, :have_output
end
