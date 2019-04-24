Feature: Overwrite a file

  As a user of aruba
  I want to overwrite a file

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Overwrite an existing file
    Given a file named "features/create_file.feature" with:
    """
    Feature: Overwrite file
      Scenario: Overwrite file
        Given a file named "file1.txt" with:
        \"\"\"
        Hello World
        \"\"\"
        And a file named "file2.txt" with:
        \"\"\"
        Hello World
        \"\"\"
        And a file named "file3.txt" with:
        \"\"\"
        Hello World
        \"\"\"
        When I overwrite "file1.txt" with:
        \"\"\"
        Hello Universe
        \"\"\"
        When I overwrite the file "file2.txt" with:
        \"\"\"
        Hello Universe
        \"\"\"
        When I overwrite a file named "file3.txt" with:
        \"\"\"
        Hello Universe
        \"\"\"
        Then the file named "file1.txt" should contain:
        \"\"\"
        Hello Universe
        \"\"\"
        And the file named "file2.txt" should contain:
        \"\"\"
        Hello Universe
        \"\"\"
        And the file named "file3.txt" should contain:
        \"\"\"
        Hello Universe
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Overwrite a non-existing file
    Given a file named "features/create_file.feature" with:
    """
    Feature: Overwrite file
      Scenario: Overwrite file
        When I overwrite "file1.txt" with:
        \"\"\"
        Hello Universe
        \"\"\"
        Then the file named "file1.txt" should contain:
        \"\"\"
        Hello Universe
        \"\"\"
    """
    When I run `cucumber`
    Then the features should not all pass with regex:
    """
    Expected [^ ]+ to be present
    """
