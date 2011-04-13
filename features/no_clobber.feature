Feature: No clobber

  By default Aruba removes its scratch directory before
  every scenario. This isn't always the right thing
  to do, especially when the path to the default directory
  has been changed. Use @no-clobber to stop Aruba from
  cleaning up after itself.

  Scenario: Change the filesystem
    Given a directory named "foo/bar"
    And a file named "foo/bar/baz.txt" with:
      """
      I don't want to die!
      """

  @no-clobber
  Scenario: Verify nothing was clobbered
    Then a file named "foo/bar/baz.txt" should exist
    And the file "foo/bar/baz.txt" should contain exactly:
      """
      I don't want to die!
      """

  Scenario: Cleanup and verify the previous scenario
    Then a file named "foo/bar/baz.txt" should not exist
