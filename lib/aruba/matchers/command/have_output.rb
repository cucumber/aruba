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
    @old_actual = actual

    next false unless @old_actual.respond_to? :output

    @announcer ||= Aruba::Announcer.new(
      self,
      :stdout => @announce_stdout,
      :stderr => @announce_stderr,
      :dir    => @announce_dir,
      :cmd    => @announce_cmd,
      :env    => @announce_env
    )

    @old_actual.stop(@announcer) unless @old_actual.stopped?
    @actual = Aruba::Platform.unescape(actual.output.chomp, aruba.config.keep_ansi)

    values_match?(expected, @actual)
  end

  diffable

  description { "have output: #{description_of expected}" }
end

if RSpec::Expectations::Version::STRING >= '3.0'
  RSpec::Matchers.alias_matcher :a_command_having_output, :have_output
end
