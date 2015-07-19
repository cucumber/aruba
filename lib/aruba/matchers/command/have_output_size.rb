# @!method have_output_size(output)
#   This matchers checks if output has size.
#
#   @param [String] output
#     The content which should be checked
#
#   @return [TrueClass, FalseClass] The result
#
#     false:
#     * if output does not have size
#     true:
#     * if output has size
#
#   @example Use matcher
#
#     RSpec.describe do
#       it { expect(file1).to have_output_size(256) }
#     end
RSpec::Matchers.define :have_output_size do |expected|
  match do |actual|
    next false unless actual.respond_to? :size

    @actual = actual.size
    values_match? expected, @actual
  end

  description { "output has size #{description_of expected}" }
end
