require 'rspec/expectations/version'

# @!method be_a_command_found_in_path
#   This matchers checks if <command> can be found in path
#
#   @return [TrueClass, FalseClass] The result
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
    @actual = Shellwords.split(actual.commandline).first if actual.respond_to? :commandline

    !which(@actual).nil?
  end

  failure_message do |actual|
    format(%(expected that command "%s" can be found in PATH "#{ENV['PATH']}".), actual)
  end

  failure_message_when_negated do |actual|
    format(%(expected that command "%s" cannot be found in PATH "#{ENV['PATH']}".), actual)
  end
end

if RSpec::Expectations::Version::STRING >= '3.0'
  RSpec::Matchers.alias_matcher :a_command_found_in_path, :be_a_command_found_in_path
end
