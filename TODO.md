* Replace check filesystem permissons through a better rspec matcher
* Improve documentation for matchers in file
* Cleanup stdout/stderr in spawn process:
    It should be enough to use 'open(@process.io.stdout).read' and 'open(@process.io.stderr).read'. There's no need to rewind them.
* Ensure that all processes are kill after cucumber is finished
* Add variation of check and stop of command if output contains
    Add something like `(?: of last command)?`. If this is true, just check the last command.
* Use aruba.config.exit_timeout everywhere
* Fix problem with long running commands in background:

  Since we need to stop all commands to access the status of the last command
  stopped, we have problems with long running commands

