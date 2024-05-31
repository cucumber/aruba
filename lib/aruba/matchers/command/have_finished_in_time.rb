# frozen_string_literal: true

# @!method run_too_long
#   This matchers checks if <command> run too long. Say the timeout is 10
#   seconds and it takes <command> to finish in 15. This matchers will succeed.
#
#   @return [Boolean] The result
#
#     false:
#     * if command not to run too long
#     true:
#     * if command run too long
#
#   @example Use matcher
#
#     RSpec.describe do
#       it { expect(last_command_started).to run_too_long }
#       it { expect(last_command_started).not_to run_too_long }
#       it { expect(last_command_started).to finish_its_run_in_time }
#     end
# RSpec::Matchers.define :run_too_long do
RSpec::Matchers.define :have_finished_in_time do
  match do |actual|
    @old_actual = actual
    @actual     = @old_actual.commandline

    unless @old_actual.respond_to? :timed_out?
      raise "Expected #{@old_actual} to respond to #timed_out?"
    end

    @old_actual.stop

    @old_actual.timed_out? == false
  end
end

RSpec::Matchers.define_negated_matcher :run_too_long, :have_finished_in_time
