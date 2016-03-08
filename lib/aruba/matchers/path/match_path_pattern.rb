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
    Aruba.platform.deprecated('The use of `expect().to match_path_pattern` is deprecated. Please use `expect().to include pattern /regex/` instead.')

    next !actual.select { |a| a == expected }.empty? if expected.is_a? String

    !actual.grep(expected).empty?
  end

  failure_message do |actual|
    format("expected that path \"%s\" matches pattern \"%s\".", actual.join(", "), expected)
  end

  failure_message_when_negated do |actual|
    format("expected that path \"%s\" does not match pattern \"%s\".", actual.join(", "), expected)
  end
end
