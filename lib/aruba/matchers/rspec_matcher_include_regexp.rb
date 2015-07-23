# @!method include_regexp(regexp)
#   This matchers checks if items of an <array> matches regexp
#
#   @param [Regexp] regexp
#     The regular expression to use
#
#   @return [TrueClass, FalseClass] The result
#
#     false:
#     * if regexp does not match
#     true:
#     * if regexp matches
#
#   @example Use matcher
#
#     RSpec.describe do
#       it { expect(%w(asdf qwert)).to include_regexp(/asdf/) }
#     end
RSpec::Matchers.define :include_regexp do |expected|
  match do |actual|
    Aruba.platform.deprecated('The use of "include_regexp"-matchers is deprecated. It will be removed soon.')

    !actual.grep(expected).empty?
  end
end
