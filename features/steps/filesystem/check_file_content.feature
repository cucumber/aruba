Feature: Check file content

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Check file contents with plain text
    Given a file named "features/non-existence.feature" with:
    """
    Feature: Check
      Scenario: Check
        Given a file named "foo" with:
        \"\"\"
        hello world
        \"\"\"
        Then the file "foo" should contain "hello world"
        And the file "foo" should not contain "HELLO WORLD"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Check file contents with regular expression
    Given a file named "features/non-existence.feature" with:
    """
    Feature: Check
      Background:
        Given a file named "foo" with:
        \"\"\"
        hello world
        \"\"\"

      Scenario: Check #1
        Then the file "foo" should match /hel.o world/
        And the file "foo" should not match /HELLO WORLD/

      Scenario: Check #2
        Then the file "foo" should match %r<hel.o world>
        And the file "foo" should not match %r<HELLO WORLD>
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario:  Check file contents with cucumber doc string
    Given a file named "features/non-existence.feature" with:
    """
    Feature: Existence
      Scenario: Existence
        Given a file named "foo" with:
        \"\"\"
        foo
        bar
        baz
        foobar
        \"\"\"
        Then the file "foo" should contain:
        \"\"\"
        bar
        baz
        \"\"\"
        """
    When I run `cucumber`
    Then the features should all pass
