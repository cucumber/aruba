# @!method have_output_on_stdout
#   This matchers checks if <command> has created output on stdout
#
#   @return [TrueClass, FalseClass] The result
#
#     false:
#     * if command has not created output on stdout
#     true:
#     * if command created output on stdout
#
#   @example Use matcher
#
#     RSpec.describe do
#       it { expect(last_command_started).to have_output_on_stdout }
#     end
RSpec::Matchers.define :have_output_on_stdout do |expected|
  match do |actual|
    @old_actual = actual

    next false unless @old_actual.respond_to? :stdout

    @announcer ||= Aruba::Announcer.new(
      self,
      :stdout => @announce_stdout,
      :stderr => @announce_stderr,
      :dir    => @announce_dir,
      :cmd    => @announce_cmd,
      :env    => @announce_env
    )

    @old_actual.stop(@announcer) unless @old_actual.stopped?

    @actual = unescape_text(actual.stdout.chomp)
    @actual = extract_text(@actual) if !aruba.config.keep_ansi || aruba.config.remove_ansi_escape_sequences

    values_match?(expected, @actual)
  end

  diffable

  description { "have output on stdout: #{description_of expected}" }
end
