require 'rspec/expectations/version'

# @!method be_an_existing_path
#   This matchers checks if <path> exists in filesystem
#
#   @return [TrueClass, FalseClass] The result
#
#     false:
#     * if path does not exist
#     true:
#     * if path exists
#
#   @example Use matcher
#
#     RSpec.describe do
#       it { expect(file).to be_an_existing_path }
#       it { expect(directory).to be_an_existing_path }
#       it { expect(all_directories).to all be_an_existing_path }
#       it { expect(all_directories).to include an_existing_path }
#     end
RSpec::Matchers.define :be_an_existing_path do |_|
  match do |actual|
    exist?(actual)
  end

  failure_message do |actual|
    format("expected that path \"%s\" exists", actual)
  end

  failure_message_when_negated do |actual|
    format("expected that path \"%s\" does not exist", actual)
  end
end

if RSpec::Expectations::Version::STRING >= '3.0'
  RSpec::Matchers.alias_matcher :an_existing_path, :be_an_existing_path
end
