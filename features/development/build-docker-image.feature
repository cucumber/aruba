Feature: Build docker image

  As a aruba developer
  I want to build the docker image for the `aruba` gem
  In order to check my changed code

  Scenario: Build the image

    The build can be parameterized by using:

    \* Disable cache

      ```
      rake 'docker:build[false]'
      ```

    \* Build image with version tag

      ```
      rake 'docker:build[false, 0.1.0]'
      ```

    When I successfully run `rake -T docker:build`
    Then the output should contain:
    """
    rake docker:build
    """
