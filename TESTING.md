## Running tests using Docker (recommended!)

NOTE: Since custom user shell/app settings can break tests, it's recommended
to use Docker for running tests. The advantages are:

1. You still can run tests directly on your modified sources.
2. Almost as fast as running tests on your host.
3. Guarantees tests won't be affected by your setup (OS, shell, app versions).
4. You can avoid installing all the test-related gems/tools on your system.
5. You can test various combinations of different versions of Ruby and tools.
6. It's easier to reproduce problems without messing around with your own system.
7. You can share your container with others (so they can see the reproduced scenario too).

To run tests using Docker, just run:

    # Automaticaly build Docker image with cached gems and run tests
    bundle exec rake docker:build && bundle exec rake docker:run

or using Docker Compose:

    # Automaticaly build Docker image with cached gems and run tests
    docker-compose run tests

And if you get any failures on a fresh checkout, report them first so they're
fixed quickly.

You can also run specific tests/scenarios/commands, e.g.:

    # Run given cucumber scenario in Docker using rake
    bundle exec rake "docker:run[cucumber features/steps/command/shell.feature:14]"

or

    # Run given cucumber scenario in Docker using Docker Compose
    docker-compose run tests bash -l -c cucumber features/steps/command/shell.feature:14

## Running tests locally (mail fail depending on your setup)

First, bootstrap your environment with this command:

    # Bootstrap environment
    script/bootstrap

(This will check system requirements and install needed gems).

Then, you can run the tests.

    # Run the test suite
    script/test

Or, you can run a specific test or scenario, e.g.

    # Run only selected Cucumber scenario
    script/test cucumber features/steps/command/shell.feature:14
