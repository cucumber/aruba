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
    @old_actual = actual

    next false unless @old_actual.respond_to? :stderr

    @announcer ||= Aruba::Announcer.new(
      self,
      :stdout => @announce_stdout,
      :stderr => @announce_stderr,
      :dir    => @announce_dir,
      :cmd    => @announce_cmd,
      :env    => @announce_env
    )

    @old_actual.stop(@announcer) unless @old_actual.stopped?
    @actual = Aruba::Platform.unescape(actual.stderr.chomp, aruba.config.keep_ansi)

    values_match?(expected, @actual)
  end

  diffable

  description { "have output on stderr: #{description_of expected}" }
end
