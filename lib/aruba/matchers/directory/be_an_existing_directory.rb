# frozen_string_literal: true

# @!method be_an_existing_directory
#   This matchers checks if <directory> exists in filesystem
#
#   @return [Boolean] The result
#
#     false:
#     * if directory does not exist
#     true:
#     * if directory exists
#
#   @example Use matcher
#
#     RSpec.describe do
#       it { expect(directory1).to be_an_existing_directory }
#     end
RSpec::Matchers.define :be_an_existing_directory do |_|
  match do |actual|
    stop_all_commands

    raise 'String expected' unless actual.is_a? String

    directory?(actual)
  end

  failure_message do |actual|
    format('expected that directory "%s" exists', actual)
  end

  failure_message_when_negated do |actual|
    format('expected that directory "%s" does not exist', actual)
  end
end

RSpec::Matchers.alias_matcher :an_existing_directory, :be_an_existing_directory
