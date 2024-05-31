# frozen_string_literal: true

# @!method have_exit_status(status)
#   This matchers checks if <command> has exit status <status>
#
#   @param [Integer] status
#     The value of the exit status
#
#   @return [Boolean] The result
#
#     false:
#     * if command does not have exit status
#     true:
#     * if command has exit status
#
#   @example Use matcher
#
#     RSpec.describe do
#       it { expect(last_command_started).to have_exit_status(0) }
#     end
RSpec::Matchers.define :have_exit_status do |expected|
  match do |actual|
    actual.stop
    @actual_exit_status = actual.exit_status

    values_match? expected, @actual_exit_status
  end

  failure_message do |actual|
    format(
      %(expected that command "%s" has exit status of "%s", but has "%s".),
      actual.commandline,
      expected.to_s,
      @actual_exit_status.to_s
    )
  end

  failure_message_when_negated do |actual|
    format(
      %(expected that command "%s" does not have exit status of "%s", but has "%s".),
      actual.commandline,
      expected.to_s,
      @actual_exit_status.to_s
    )
  end
end
