Feature: Run a docker container

  As a aruba developer
  I want to build the docker image for the `aruba` gem
  In order to check my changed code

  Scenario: Run the container with default options

    You can run a specific command within the container:

    ~~~
    rake 'docker:run[cmd]'
    ~~~

    Or just use the default one

    ~~~
    rake 'docker:run'
    ~~~

    When I successfully run `rake -T docker:run`
    Then the output should contain:
    """
    rake docker:run
    """
