# frozen_string_literal: true

# @!method have_output_on_stdout
#   This matchers checks if <command> has created output on stdout
#
#   @return [Boolean] The result
#
#     false:
#     * if command has not created output on stdout
#     true:
#     * if command created output on stdout
#
#   @example Use matcher
#
#     RSpec.describe do
#       it { expect(last_command_started).to have_output_on_stdout }
#     end
RSpec::Matchers.define :have_output_on_stdout do |expected|
  match do |actual|
    @old_actual = actual

    unless @old_actual.respond_to? :stdout
      raise "Expected #{@old_actual} to respond to #stdout"
    end

    @old_actual.stop

    @actual = sanitize_text(actual.stdout)

    values_match?(expected, @actual)
  end

  diffable

  description { "have output on stdout: #{description_of expected}" }
end
