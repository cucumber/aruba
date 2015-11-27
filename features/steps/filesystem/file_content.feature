Feature: Check file content

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Existing file having content
    Given a file named "features/file_content.feature" with:
    """
    Feature: File content
      Scenario: file content
        Given a file named "test.txt" with:
        \"\"\"
        Hello World
        \"\"\"
        Then the file named "test.txt" should contain:
        \"\"\"
        Hello World
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Existing file having content with special characters
    Given a file named "features/file_content.feature" with:
    """
    Feature: File content
      Scenario: file content
        Given a file named "test.txt" with:
        \"\"\"
        UUUUU

        1 scenario (1 undefined)
        5 steps (5 undefined)

        \"\"\"
        Then the file named "test.txt" should contain:
        \"\"\"
        UUUUU

        1 scenario (1 undefined)
        5 steps (5 undefined)

        \"\"\"
    """
    When I run `cucumber --format progress`
    Then the features should all pass

  Scenario: Trailing white space is ignored
    Given a file named "features/file_content.feature" with:
    """
    Feature: File content
      Scenario: file content
        Given a file named "test.txt" with:
        \"\"\"
        UUUUU

        \"\"\"
        Then the file named "test.txt" should contain:
        \"\"\"
        UUUUU
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Use non-ASCII UTF-8 characters
    Given a file named "features/file_content.feature" with:
    """
    Feature: File content
      Scenario: file content
        Given a file named "test.txt" with:
        \"\"\"
        フィーチャ
        \"\"\"
        When I run `cat test.txt`
        Then the output should contain:
        \"\"\"
        フィーチャ
        \"\"\"
        And the file named "test.txt" should contain:
        \"\"\"
        フィーチャ
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass
