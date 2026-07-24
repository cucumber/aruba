# frozen_string_literal: true

# @!method have_output_size
#   This matcher checks if the process has produced output of a given size.
#
#   @param [Aruba::Process:BasicProcess] process
#     The process whose output should be checked
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
#       it { expect(last_command_started).to have_output_size(256) }
#     end
RSpec::Matchers.define :have_output_size do |expected|
  match do |actual|
    raise "Expected #{actual} to respond to #output" unless actual.respond_to? :output

    actual_size = actual.output.size

    values_match? expected, actual_size
  end

  description { "output has size #{description_of expected}" }
end
