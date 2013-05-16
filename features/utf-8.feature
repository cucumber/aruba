Feature: UTF-8

  Scenario: Write then assert on the content of a file with UTF-8 characters in
    Given a file named "turning-japanese" with:
      """
      フィーチャ

      """
    And I run `cat turning-japanese`
    Then the output should contain exactly:
      """
      フィーチャ

      """
