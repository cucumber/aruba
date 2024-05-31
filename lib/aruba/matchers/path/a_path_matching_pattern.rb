# frozen_string_literal: true

# @!method a_path_matching_pattern(/pattern/)
#   This matchers checks if <path> matches pattern. `pattern` can be a string,
#   regexp or an RSpec matcher.
#
#   @param [String, Regexp, Matcher] pattern
#     Specifies the pattern
#
#   @return [Boolean] The result
#
#     false:
#     * if pattern does not match
#
#     true:
#     * if pattern matches
#
#   @example Use matcher with regexp
#
#     RSpec.describe do
#       it { expect(files).to include a_path_matching_pattern /asdf/ }
#     end
RSpec::Matchers.alias_matcher :a_path_matching_pattern, :match
