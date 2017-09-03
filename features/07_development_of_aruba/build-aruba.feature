Feature: Build Aruba Gem

  As a aruba developer
  I want to build the `aruba` gem
  In order to install it

  Scenario: Building aruba using rake task

    To build the `aruba`-gem you can use the `gem:build`-rake task.

    Given I successfully run `rake rubygem:build`
    Then the output should match %r<aruba \d+\.\d+\.\d+[\.\w]* built to pkg/aruba-\d+\.\d+\.\d+[\.\w]*\.gem>
