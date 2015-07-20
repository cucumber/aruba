# @!method have_output_on_stderr
#   This matchers checks if <command> has created output on stderr
#
#   @return [TrueClass, FalseClass] The result
#
#     false:
#     * if command has not created output on stderr
#     true:
#     * if command created output on stderr
#
#   @example Use matcher
#
#     RSpec.describe do
#       it { expect(last_command_started).to have_output_on_stderr }
#     end
RSpec::Matchers.define :have_output_on_stderr do |expected|
  match do |actual|
    next false unless actual.respond_to? :stderr

    @old_actual = actual
    @actual = actual.stderr.chomp

    values_match?(expected, @actual)
  end

  diffable

  description { "have output on stderr: #{description_of expected}" }
end
