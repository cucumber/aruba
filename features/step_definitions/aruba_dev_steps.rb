Given(/^the default executable$/) do
  step 'an executable named "bin/aruba-test-cli" with:', <<-EOS
#!/usr/bin/env ruby

$LOAD_PATH << File.expand_path('../../lib', __FILE__)
require 'cli/app'

exit 0
  EOS
end

Given(/^the default feature-test$/) do
  step(
    'a file named "features/default.feature" with:',
    <<-EOS.strip_heredoc
    Feature: Default Feature

      This is the default feature

      Scenario: Run command
        Given I successfully run `aruba-test-cli`
    EOS
  )
end
