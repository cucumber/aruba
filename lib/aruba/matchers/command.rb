# @!method have_exit_status(status)
#   This matchers checks if <command> has exit status <status>
#
#   @param [Integer] status
#     The value of the exit status
#
#   @return [TrueClass, FalseClass] The result
#
#     false:
#     * if command does not have exit status
#     true:
#     * if command has exit status
#
#   @example Use matcher
#
#     RSpec.describe do
#       it { expect(last_command).to have_exit_status(0) }
#     end
RSpec::Matchers.define :have_exit_status do |expected|
  match do |actual|
    @old_actual = actual

    @old_actual.stop unless @old_actual.stopped?
    @actual = actual.exit_status

    next false unless @old_actual.respond_to? :exit_status

    values_match? expected, @actual
  end

  failure_message do |actual|
    format(%(expected that command "%s" has exit status of "%s", but has "%s".), @old_actual.commandline, expected.to_s, actual.to_s)
  end

  failure_message_when_negated do |actual|
    format(%(expected that command "%s" does not have exit status of "%s", but has "%s".), @old_actual.commandline, expected.to_s, actual.to_s)
  end
end

# @!method be_successfuly_executed
#   This matchers checks if execution of <command> was successful
#
#   @return [TrueClass, FalseClass] The result
#
#     false:
#     * if command was not successful
#     true:
#     * if command was successful
#
#   @example Use matcher
#
#     RSpec.describe do
#       it { expect(last_command).to be_successfully_executed }
#     end
RSpec::Matchers.define :be_successfully_executed do
  match do |actual|
    @old_actual = actual
    @actual = actual.exit_status

    expect(@old_actual).to have_exit_status 0
  end

  failure_message do |actual|
    format(%(expected that command "%s" has exit status of "%s", but has "%s".), @old_actual.commandline, '0', actual.to_s)
  end

  failure_message_when_negated do |actual|
    format(%(expected that command "%s" does not have exit status of "%s", but has "%s".), @old_actual.commandline, '0', actual.to_s)
  end
end
