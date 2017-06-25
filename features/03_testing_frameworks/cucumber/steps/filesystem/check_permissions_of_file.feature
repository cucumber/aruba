Feature: Check permissions of file

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Check mode of existing file
    Given a file named "features/create_file.feature" with:
    """
    Feature: Check
      Background:
        Given an empty file named "file1.txt" with mode "0644"

      Scenario: Check #1
        Then the file named "file1.txt" should have permissions "0644"

      Scenario: Check #2
        Then a file "file1.txt" should have permissions "0644"

      Scenario: Check #3
        Then a file "file1.txt" should not have permissions "0444"

      Scenario: Check #4
        Then the file "file1.txt" should not have permissions "0444"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Check mode of non-existing file
    Given a file named "features/create_file.feature" with:
    """
    Feature: Check
      Background:
        Given a file named "file1.txt" does not exist

      Scenario: Check 
        Then the file named "file1.txt" should have permissions "0644"
    """
    When I run `cucumber`
    Then the features should not pass
