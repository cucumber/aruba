Feature: Output

  In order to specify expected output
  As a developer using Cucumber
  I want to use the "the output should contain" step

  Scenario: Run unknown command
    When I run "neverever gonna work"
    Then the output should contain:
    """
    No such file or directory - neverever gonna work
    """

	Scenario: Run unknown command, regardless of case
	  When I run "neverever gonna work"
	  Then the output should, regardless of case, contain:
	  """
	  no such file or directory - neverever gonna work
	  """

  Scenario: Detect subset of one-line output
    When I run "ruby -e 'puts \"hello world\"'"
    Then the output should contain "hello world"

  Scenario: Detect subset of one-line output
    When I run "echo 'hello world'"
    Then the output should contain "hello world"

  Scenario: Detect subset of one-line output, regardless of case
    When I run "echo 'Hello World'"
    Then the output should, regardless of case, contain "hello world"

  Scenario: Detect absence of one-line output
    When I run "ruby -e 'puts \"hello world\"'"
    Then the output should not contain "good-bye"
		 And the output should not contain "Hello World"

  Scenario: Detect absence of one-line output, regardless of case
    When I run "ruby -e 'puts \"hello world\"'"
    Then the output should not, regardless of case, contain "good-bye"

  Scenario: Detect subset of multiline output
    When I run "ruby -e 'puts \"hello\\nworld\"'"
    Then the output should contain:
      """
      hello
      """

  Scenario: Detect subset of multiline output, regardless of case
    When I run "ruby -e 'puts \"hello\\nworld\"'"
    Then the output should, regardless of case, contain:
      """
      Hello
      """

  Scenario: Detect subset of multiline output
    When I run "ruby -e 'puts \"hello\\nworld\"'"
    Then the output should not contain:
      """
      good-bye
      """
     And the output should not contain:
      """
      Hello
      """

	Scenario: Detect subset of multiline output, regardless of case
	  When I run "ruby -e 'puts \"hello\\nworld\"'"
	  Then the output should not, regardless of case, contain:
	    """
	    good-bye
	    """

  Scenario: Detect exact one-line output
    When I run "ruby -e 'puts \"hello world\"'"
    Then the output should contain exactly "hello world\n"

  Scenario: Detect exact one-line output, regardless of case
    When I run "ruby -e 'puts \"Hello World\"'"
    Then the output should, regardless of case, contain exactly "hello world\n"

  Scenario: Detect exact multiline output
    When I run "ruby -e 'puts \"hello\\nworld\"'"
    Then the output should contain exactly:
      """
      hello
      world

      """

  Scenario: Detect exact multiline output, regardless of case
    When I run "ruby -e 'puts \"Hello\\nWorld\"'"
    Then the output should, regardless of case, contain exactly:
      """
      hello
      world

      """

  @announce
  Scenario: Detect subset of one-line output with regex
    When I run "ruby --version"
    Then the output should contain "ruby"
    And the output should match /ruby ([\d]+\.[\d]+\.[\d]+)(p\d+)? \(.*$/
		

	@announce
	Scenario: Detect subset of one-line output with regex, regardless of case
	  When I run "ruby --version"
	  Then the output should contain "ruby"
	  And the output should match /RuBy ([\d]+\.[\d]+\.[\d]+)(p\d+)? \(.*$/i

  @announce
  Scenario: Do not detect unwanted text in subset of one-line output with regex
    When I run "ruby --version"
    Then the output should contain "ruby"
		And the output should not match /Ruby/
    And the output should not match /python/

  @announce
  Scenario: Do not detect unwanted text in subset of one-line output with regex, regardless of case
    When I run "ruby --version"
    Then the output should contain "ruby"
    And the output should not match /Python/i

  @announce
  Scenario: Detect subset of multiline output with regex
    When I run "ruby -e 'puts \"hello\\nworld\\nextra line1\\nextra line2\\nimportant line\"'"
    Then the output should match:
      """
      he..o
      wor.d
      .*
      important line
      """

  @announce
  Scenario: Detect subset of multiline output with regex, regardless of case
    When I run "ruby -e 'puts \"Hello\\nWorld\\nExtra line1\\nExtra line2\\nIMPORTANT LINE\"'"
    Then the output should, regardless of case, match:
	    """
	    he..o
	    wor.d
	    .*
	    important line
	    """

  @announce
  Scenario: Do not detect unwanted text in subset of multiline output with regex
  When I run "ruby -e 'puts \"Hello\\nWorld\\nExtra line1\\nExtra line2\\nIMPORTANT LINE\"'"
    Then the output should not match:
      """
      g..bye
      cruel worl.d
      .*
      unimportant blurb
      """
		And the output should not match:
	    """
	    he..o
	    wor.d
	    .*
	    important line
	    """

	@announce
	Scenario: Do not detect unwanted text in subset of multiline output with regex, regardless of case
	  When I run "ruby -e 'puts \"hello\\nworld\\nextra line1\\nextra line2\\nimportant line\"'"
	  Then the output should not, regardless of case, match:
	    """
	    G..bye
	    Cruel Worl.d
	    .*
	    EXCLAMATION!
	    """

  @announce
  Scenario: Match passing exit status and partial output
    When I run "ruby -e 'puts \"hello\\nworld\"'"
    Then it should pass with:
      """
      hello
      """

  @announce
  Scenario: Match passing exit status and partial output, regardless of case
    When I run "ruby -e 'puts \"Hello\\nWorld\"'"
    Then it should, regardless of case, pass with:
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

  @announce-stdout
  Scenario: Match failing exit status and partial output, regardless of case
    When I run "ruby -e 'puts \"Hello\\nWorld\";exit 99'"
    Then it should, regardless of case, fail with:
      """
      hello
      """

  @announce-stdout
  Scenario: Match failing exit status and output with regex
    When I run "ruby -e 'puts \"hello\\nworld\";exit 99'"
    Then it should fail with regex:
      """
      hello\s*world
      """

	@announce-stdout
	Scenario: Match failing exit status and output with regex, regardless of case
	  When I run "ruby -e 'puts \"Hello\\nWorld\";exit 99'"
	  Then it should, regardless of case, fail with regex:
      """
      hello\s*world
      """

  @announce-cmd
  Scenario: Match output in stdout
    When I run "ruby -e 'puts \"hello\\nworld\"'"
    Then the stdout should contain "hello"
    Then the stderr should not contain "hello"

  @announce-cmd
  Scenario: Match output in stdout, regardless of case
    When I run "ruby -e 'puts \"Hello\\nWorld\"'"
    Then the stdout should, regardless of case, contain "hello"
    Then the stderr should not, regardless of case, contain "hello"

  @announce-stderr
  Scenario: Match output in stderr
    When I run "ruby -e 'STDERR.puts \"hello\\nworld\";exit 99'"
    Then the stderr should contain "hello"
    Then the stdout should not contain "hello"

  @announce-stderr
  Scenario: Match output in stderr, regardless of case
    When I run "ruby -e 'STDERR.puts \"Hello\\nWorld\";exit 99'"
    Then the stderr should, regardless of case, contain "hello"
    Then the stdout should not, regardless of case, contain "hello"
