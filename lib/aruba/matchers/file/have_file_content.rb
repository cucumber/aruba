# @!method have_file_content(content)
#   This matchers checks if <file> has content. `content` can be a string,
#   regexp or an RSpec matcher.
#
#   @param [String, Regexp, Matcher] content
#     Specifies the content of the file
#
#   @return [TrueClass, FalseClass] The result
#
#     false:
#     * if file does not exist
#     * if file content is not equal string
#     * if file content does not include regexp
#     * if file content does not match the content specification
#
#     true:
#     * if file content includes regexp
#     * if file content is equal string
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
#       it { expect(file1).to have_file_content(a_string_starting_with 'a') }
#     end
RSpec::Matchers.define :have_file_content do |expected|
  match do |actual|
    stop_processes!

    next false unless file? actual

    values_match?(expected, File.read(expand_path(actual)).chomp)
  end

  description { "have file content: #{description_of expected}" }
end

