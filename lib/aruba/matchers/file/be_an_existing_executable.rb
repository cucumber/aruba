require 'rspec/expectations/version'
require 'shellwords'

# @!method be_an_existing_executable
#   This matchers checks if <file> exists in filesystem
#
#   @return [TrueClass, FalseClass] The result
#
#     false:
#     * if file does not exist
#     true:
#     * if file exists
#
#   @example Use matcher
#
#     RSpec.describe do
#       it { expect(file1).to be_an_existing_executable }
#     end
RSpec::Matchers.define :be_an_existing_executable do |_|
  match do |actual|
    @actual = Shellwords.split(actual.commandline).first if actual.respond_to? :commandline

    executable?(@actual)
  end

  failure_message do |actual|
    format("expected that executable \"%s\" exists", actual)
  end

  failure_message_when_negated do |actual|
    format("expected that executable \"%s\" does not exist", actual)
  end
end

if RSpec::Expectations::Version::STRING >= '3.0'
  RSpec::Matchers.alias_matcher :an_existing_executable, :be_an_existing_executable
end
