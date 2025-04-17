# frozen_string_literal: true

require 'aruba/matchers/command/have_exit_status'
require 'aruba/matchers/command/have_finished_in_time'

# @!method be_successfuly_executed
#   This matchers checks if execution of <command> was successful
#
#   @return [Boolean] The result
#
#     false:
#     * if command was not successful
#     true:
#     * if command was successful
#
#   @example Use matcher
#
#     RSpec.describe do
#       it { expect(last_command_started).to be_successfully_executed }
#       it { expect(last_command_started).not_to be_successfully_executed }
#       it { expect(last_command_started).to have_failed_running }
#     end
RSpec::Matchers.define :be_successfully_executed do
  match do |actual|
    @old_actual = actual
    @actual     = @old_actual.commandline

    expect(@old_actual).to have_exit_status(0)
  end

  failure_message do |_actual|
    "Expected `#{@actual}` to succeed " \
      'but got non-zero exit status and the following output:' \
      "\n\n#{@old_actual.output}\n"
  end
end

RSpec::Matchers.define_negated_matcher :have_failed_running, :be_successfully_executed
