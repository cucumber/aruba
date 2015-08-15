require 'rspec/expectations/version'

# @!method be_an_existing_file
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
#       it { expect(file1).to be_an_existing_file }
#     end
RSpec::Matchers.define :be_an_existing_file do |_|
  match do |actual|
    stop_all_commands

    next false unless actual.is_a? String

    file?(actual)
  end

  failure_message do |actual|
    format("expected that file \"%s\" exists", actual)
  end

  failure_message_when_negated do |actual|
    format("expected that file \"%s\" does not exist", actual)
  end
end

if RSpec::Expectations::Version::STRING >= '3.0'
  RSpec::Matchers.alias_matcher :an_existing_file, :be_an_existing_file
end
