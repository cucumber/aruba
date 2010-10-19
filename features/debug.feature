Feature: Debug
  In order to value
  As a role
  I want feature

@active
Scenario Outline: Detect subset of one-line output
    When I run "<command_line> "
    Then the output should contain "<output_array>"

Scenarios: Detect subset of one-line output table
 | command_line                      | output_array             |
 | ruby -e \"puts '<output_array>'\" | line1                    |
 | ruby -e \"puts '<output_array>'\" | 'Line two' fudgy whale   |
 | ruby -e \"puts '<output_array>'\" | fudgy 'line three' whale |
 | ruby -e \"puts '<output_array>'\" | fudgy whale 'line four'  |
 | ruby -e \"puts '<output_array>'\" | 'line five'              |
 | ruby -e \"puts '<output_array>'\" | line six                 |


#@active
Scenario: Detect subset of one-line output, regardless of case
  When I run "echo 'Hello World'"
  Then the output should, regardless of case, contain "hello world"

  
#@active
Scenario: create a dir
  Given a directory named "foo/bar"
  When I run "ruby -e \"puts test ?d, 'foo'\""
  Then the stdout should contain "true"

#@active
Scenario: Detect subset of multiline output, regardless of case
  When I run "ruby -e 'puts \"hello\\nworld\"'"
  Then the output should, regardless of case, contain:
    """
    Hello
    """
