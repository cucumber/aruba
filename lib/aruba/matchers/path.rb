# @!method match_path_pattern(pattern)
#   This matchers checks if <files>/directories match <pattern>
#
#   @param [String, Regexp] pattern
#     The pattern to use.
#
#   @return [TrueClass, FalseClass] The result
#
#     false:
#     * if there are no files/directories which match the pattern
#     true:
#     * if there are files/directories which match the pattern
#
#   @example Use matcher with regex
#
#     RSpec.describe do
#       it { expect(Dir.glob(**/*)).to match_file_pattern(/.txt$/) }
#     end
#
#   @example Use matcher with string
#
#     RSpec.describe do
#       it { expect(Dir.glob(**/*)).to match_file_pattern('.txt$') }
#     end
RSpec::Matchers.define :match_path_pattern do |_|
  match do |actual|
    next  !actual.select { |a| a == expected }.empty? if expected.is_a? String

    !actual.grep(expected).empty?
  end

  failure_message do |actual|
    format("expected that path \"%s\" matches pattern \"%s\".", actual.join(", "), expected)
  end

  failure_message_when_negated do |actual|
    format("expected that path \"%s\" does not match pattern \"%s\".", actual.join(", "), expected)
  end
end

# @!method be_existing_path
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
#       it { expect(file).to be_existing_path }
#       it { expect(directory).to be_existing_path }
#     end
RSpec::Matchers.define :be_existing_path do |_|
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

# @!method be_absolute_path
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
#       it { expect(file).to be_absolute_path }
#       it { expect(directory).to be_absolute_path }
#     end
RSpec::Matchers.define :be_absolute_path do |_|
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
