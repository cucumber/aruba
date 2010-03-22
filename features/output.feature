Feature: Output

  In order to specify expected output
  As a developer using Cucumber
  I want to use the "I should see" step

  Scenario: Detect subset of one-line output
    When I run "ruby -e 'puts \"hello world\"'"
    Then I should see "hello world"

  Scenario: Detect subset of one-line output
    When I run "echo 'hello world'"
    Then I should see "hello world"

  Scenario: Detect absence of one-line output
    When I run "ruby -e 'puts \"hello world\"'"
    Then I should not see "good-bye"

  Scenario: Detect subset of multiline output
    When I run "ruby -e 'puts \"hello\\nworld\"'"
    Then I should see:
      """
      hello
      """

  Scenario: Detect subset of multiline output
    When I run "ruby -e 'puts \"hello\\nworld\"'"
    Then I should not see:
      """
      good-bye
      """

  Scenario: Detect exact one-line output
    When I run "ruby -e 'puts \"hello world\"'"
    Then I should see exactly "hello world\n"

  Scenario: Detect exact multiline output
    When I run "ruby -e 'puts \"hello\\nworld\"'"
    Then I should see exactly:
      """
      hello
      world

      """

  @announce
  Scenario: Detect subset of one-line output with regex
    When I run "ruby --version"
    Then I should see "ruby"
    And I should see matching "ruby ([\d]+\.[\d]+\.[\d]+)(p\d+)? \(.*$"

  @announce
  Scenario: Detect subset of multiline output with regex
    When I run "ruby -e 'puts \"hello\\nworld\\nextra line1\\nextra line2\\nimportant line\"'"
    Then I should see matching:
      """
      he..o
      wor.d
      .*
      important line
      """

  @announce
  Scenario: Match passing exit status and partial output
    When I run "ruby -e 'puts \"hello\\nworld\"'"
    Then it should pass with:
      """
      hello
      """

  @announce-stdout
  Scenario: Match failing exit status and partial output
    When I run "ruby -e 'puts \"hello\\nworld\";exit 99'"
    Then it should fail with:
      """
      hello
      """

  @announce-cmd
  Scenario: Match output in stdout
    When I run "ruby -e 'puts \"hello\\nworld\"'"
    Then the stdout should contain "hello"
    Then the stderr should not contain "hello"

  @announce-stderr
  Scenario: Match output in stderr
    When I run "ruby -e 'STDERR.puts \"hello\\nworld\";exit 99'"
    Then the stderr should contain "hello"
    Then the stdout should not contain "hello"
