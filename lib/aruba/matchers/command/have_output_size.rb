# frozen_string_literal: true

# @!method have_output_size(output)
#   This matchers checks if output has size.
#
#   @param [String,Aruba::Process:BasicProcess] output or process
#     The content which should be checked, or the process whose output should be checked
#
#     Use of this matcher with a string is deprecated.
#
#   @return [Boolean] The result
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
#
#     RSpec.describe do
#       it { expect(last_command_started).to have_output_size(256) }
#     end
RSpec::Matchers.define :have_output_size do |expected|
  match do |actual|
    if actual.respond_to? :size
      Aruba.platform.deprecated \
        'Application of the have_output_size matcher to a string is deprecated. ' \
        'Apply the matcher directly to the process object instead'
      actual_size = actual.size
    elsif actual.respond_to? :output
      actual_size = actual.output.size
    else
      raise "Expected #{actual} to respond to #size or #output"
    end

    values_match? expected, actual_size
  end

  description { "output has size #{description_of expected}" }
end
