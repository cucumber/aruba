require 'aruba/matchers/command/have_exit_status'
require 'aruba/matchers/command/run_too_long'

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
    @actual = @old_actual.commandline

    expect(@old_actual).to have_exit_status(0)
  end
end
