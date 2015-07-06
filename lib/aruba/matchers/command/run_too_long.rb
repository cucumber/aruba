# @!method run_too_long
#   This matchers checks if <command> run too long. Say the timeout is 10
#   seconds and it takes <command> to finish in 15. This matchers will succeed.
#
#   @return [TrueClass, FalseClass] The result
#
#     false:
#     * if command not to run too long
#     true:
#     * if command run too long
#
#   @example Use matcher
#
#     RSpec.describe do
#       it { expect(last_command).to run_too_long }
#       it { expect(last_command).not_to run_too_long }
#       it { expect(last_command).to finish_its_run_in_time }
#     end
RSpec::Matchers.define :run_too_long do
  match do |actual|
    @old_actual = actual

    @announcer ||= Aruba::Announcer.new(
      self,
      :stdout => @announce_stdout,
      :stderr => @announce_stderr,
      :dir    => @announce_dir,
      :cmd    => @announce_cmd,
      :env    => @announce_env
    )

    @old_actual.stop(@announcer) unless @old_actual.stopped?

    next false unless @old_actual.respond_to? :timed_out?

    expect(@old_actual).to be_timed_out
  end

  failure_message do |actual|
    format %(expected that command "%s" run too long), actual.commandline
  end

  failure_message_when_negated do |actual|
    format %(expected that command "%s" has finished in time), actual.commandline
  end
end

RSpec::Matchers.define_negated_matcher :have_finished_in_time, :run_too_long
