# frozen_string_literal: true

Then(/^a directory matching %r<(.*?)> should exist$/) do |pattern|
  pattern = pattern.sub(%r{^/}, '^')
  regex = Regexp.new(pattern)
  matched = nil
  in_current_directory do
    matched = Dir.glob('**/*').find { _1 =~ regex }
  end
  expect(matched).not_to be_nil
  expect(matched).to be_an_existing_directory
end
