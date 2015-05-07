# @!method have_same_file_content_like(file_name)
#   This matchers checks if <file1> has the same content like <file2>
#
#   @param [String] file_name
#     The name of the file which should be compared with the file in the
#     `expect()`-call.
#
#   @return [TrueClass, FalseClass] The result
#
#     false:
#     * if file1 is not equal file2
#     true:
#     * if file1 is equal file2
#
#   @example Use matcher
#
#     RSpec.describe do
#       it { expect(file1).to have_same_file_content_like(file2) }
#     end
RSpec::Matchers.define :have_same_file_content_like do |expected|
  match do |actual|
    FileUtils.compare_file(
      expand_path(actual),
      expand_path(expected)
    )
  end

  failure_message do |actual|
    format("expected that file \"%s\" is the same as file \"%s\".", actual, expected)
  end

  failure_message_when_negated do |actual|
    format("expected that file \"%s\" differs from file \"%s\".", actual, expected)
  end
end

# @!method be_existing_file
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
#       it { expect(file1).to be_existing_file(file2) }
#     end
RSpec::Matchers.define :be_existing_file do |_|
  match do |actual|
    File.file?(absolute_path(actual))
  end

  failure_message do |actual|
    format("expected that file \"%s\" exists", actual)
  end

  failure_message_when_negated do |actual|
    format("expected that file \"%s\" does not exist", actual)
  end
end

# @!method have_file_content(content)
#   This matchers checks if <file> has content. `content` can be a
#   string, regexp or an RSpec matcher.
#
#   @param [String, Regexp, Matcher] content
#     Specifies the content of the file
#
#   @return [TrueClass, FalseClass] The result
#
#     false:
#     * if file does not exist
#     * if file content does not match the content specification
#     true:
#     * if file content matches the content specification
#
#   @example Use matcher with string
#
#     RSpec.describe do
#       it { expect(file1).to have_file_content('a') }
#     end
#
#   @example Use matcher with regexp
#
#     RSpec.describe do
#       it { expect(file1).to have_file_content(/a/) }
#     end
#
#   @example Use matcher with an RSpec matcher
#
#     RSpec.describe do
#       it { expect(file1).to have_file_content(a_string_starting_with "a") }
#     end
RSpec::Matchers.define :have_file_content do |expected|
  match do |actual|
    path = absolute_path(actual)
    return false unless File.file?(path)
    values_match?(expected, File.read(path).chomp)
  end

  description { "have file content: #{description_of expected}" }
end

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
#     end
RSpec::Matchers.define :have_file_size do |expected|
  match do |actual|
    next false unless File.file? expand_path(actual)
    File.size(expand_path(actual)) == expected
  end

  failure_message do |actual|
    format("expected that file \"%s\" has size \"%s\"", actual)
  end

  failure_message_when_negated do |actual|
    format("expected that file \"%s\" does not have size \"%s\"", actual)
  end
end
