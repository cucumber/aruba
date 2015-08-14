require 'rspec/expectations/version'

# @!method have_file_size(size)
#   This matchers checks if path has file size
#
#   @param [Fixnum] size
#     The size to check
#
#   @return [TrueClass, FalseClass] The result
#
#     false:
#     * if path does not have size
#     true:
#     * if path has size
#
#   @example Use matcher
#
#     RSpec.describe do
#       it { expect('file.txt').to have_file_size(0) }
#       it { expect(%w(file.txt file2.txt)).to all have_file_size(0) }
#       it { expect(%w(file.txt file2.txt)).to include a_file_of_size(0) }
#     end
RSpec::Matchers.define :have_file_size do |expected|
  match do |actual|
    stop_all_commands

    next false unless file?(actual)

    @old_actual = actual
    @actual = file_size(actual)
    @expected = expected.to_i

    values_match?(@expected, @actual)
  end

  failure_message do |actual|
    format("expected that file \"%s\" has size \"%s\", but has \"%s\"", @old_actual, @actual, @expected)
  end

  failure_message_when_negated do |actual|
    format("expected that file \"%s\" does not have size \"%s\", but has \"%s\"", @old_actual, @actual, @expected)
  end
end

if RSpec::Expectations::Version::STRING >= '3.0'
  RSpec::Matchers.alias_matcher :a_file_of_size, :have_file_size
end
