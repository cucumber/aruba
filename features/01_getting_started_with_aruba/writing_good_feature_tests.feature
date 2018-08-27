Feature: Writing good feature tests with aruba to create documentations

  You can use Markdown within your feature tests. This is quite good to write a
  living documentation.

  There are some edge cases where Gherkin and Markdown don't agree. Bullet lists
  using `*` is one example. The `*` is also an alias for step keywords in
  Gherkin. Markdown headers (the kind starting with a `#`) is another example.
  They are parsed as comments by Gherkin. To use either of these, just escape
  them with a backslash. Alternatively just use the "-".

  You'd write:

  ```gherkin
  Scenario: Make tea
    \## Making tea
    \* Get a pot
    \* And some hot water

    Given...
  ```

  This way Gherkin won't recognize these lines as special tokens, and the
  reporter will render them as Markdown. (The reporter strips away any leading
  the backslashes before handing it off to the Markdown parser).

  Another option is to use alternative Markdown syntax and omit conflicts and
  escaping altogether:

  ```gherkin
  Scenario: Make tea
    Making tea
    ----------
    - Get a pot
    - And some hot water

    Given...
  ```
