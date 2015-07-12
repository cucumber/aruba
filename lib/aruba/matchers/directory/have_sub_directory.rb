require 'rspec/expectations/version'

# @!method have_sub_directory(sub_directory)
#   This matchers checks if <directory> has given sub-directory
#
#   @param [Array] sub_directory
#      A list of sub-directory relative to current directory
#
#   @return [TrueClass, FalseClass] The result
#
#     false:
#     * if directory does not have sub-directory
#     true:
#     * if directory has sub-directory
#
#   @example Use matcher with single directory
#
#     RSpec.describe do
#       it { expect('dir1.d').to have_sub_directory('subdir.1.d') }
#     end
#
#   @example Use matcher with multiple directories
#
#     RSpec.describe do
#       it { expect('dir1.d').to have_sub_directory(['subdir.1.d', 'subdir.2.d']) }
#       it { expect(directories).to include a_directory_with_sub_directory(['subdir.1.d', 'subdir.2.d']) }
#     end
RSpec::Matchers.define :have_sub_directory do |expected|
  match do |actual|
    next false unless directory?(actual)

    @old_actual = actual
    @actual = list(actual)

    @expected = Array(expected).map { |p| File.join(@old_actual, p) }

    (@expected - @actual).empty?
  end

  diffable

  failure_message do |actual|
    format("expected that directory \"%s\" has the following sub-directories: %s.", actual.join(', '), expected)
  end

  failure_message_when_negated do |actual|
    format("expected that directory \"%s\" does not have the following sub-directories: %s.", actual.join(', '), expected)
  end
end

if RSpec::Expectations::Version::STRING >= '3.0'
  RSpec::Matchers.alias_matcher :a_directory_having_sub_directory, :have_sub_directory
end
