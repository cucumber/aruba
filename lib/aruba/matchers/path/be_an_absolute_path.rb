require 'rspec/expectations/version'

# @!method be_an_absolute_path
#   This matchers checks if <path> exists in filesystem
#
#   @return [TrueClass, FalseClass] The result
#
#     false:
#     * if path is not absolute
#     true:
#     * if path is absolute
#
#   @example Use matcher
#
#     RSpec.describe do
#       it { expect(file).to be_an_absolute_path }
#       it { expect(directory).to be_an_absolute_path }
#       it { expect(directories).to include an_absolute_path }
#     end
RSpec::Matchers.define :be_an_absolute_path do |_|
  match do |actual|
    absolute?(actual)
  end

  failure_message do |actual|
    format("expected that path \"%s\" is absolute, but it's not", actual)
  end

  failure_message_when_negated do |actual|
    format("expected that path \"%s\" is not absolute, but it is", actual)
  end
end

if RSpec::Expectations::Version::STRING >= '3.0'
  RSpec::Matchers.alias_matcher :an_absolute_path, :be_an_absolute_path
end
