# frozen_string_literal: true

# @!method be_a_command_found_in_path
#   This matchers checks if <command> can be found in path
#
#   @return [Boolean] The result
#
#     false:
#     * if command was not found in PATH
#     true:
#     * if command can be found in PATH
#
#   @example Use matcher
#
#     RSpec.describe do
#       it { expect(cmd).to be_a_command_found_in_path }
#     end
RSpec::Matchers.define :be_a_command_found_in_path do
  match do |actual|
    !which(actual).nil?
  end

  failure_message do |actual|
    format(%(expected that command "%s" can be found in PATH "%s".),
           actual, aruba.environment['PATH'])
  end

  failure_message_when_negated do |actual|
    format(%(expected that command "%s" cannot be found in PATH "%s".),
           actual, aruba.environment['PATH'])
  end
end

RSpec::Matchers.alias_matcher :a_command_found_in_path, :be_a_command_found_in_path
