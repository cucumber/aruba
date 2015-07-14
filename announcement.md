[ANN] Release aruba 0.8.0

Today we released aruba 0.8.0. This includes some major - but non-breaking - changes and we're on our way to hit 1.0.0 soon:

**Major cleanup of the API**

There's an aruba runtime which holds information about aruba's configuration,
the envionment, the current working directory, the root directory. The core of aruba was reduced five methods:

* `aruba`: Access to the aruba runtime information

  ```ruby
  # Access environment
  aruba.environment
  
  # Access configuration
  aruba.config
  
  # Access the current working directory
  aruba.current_directory
  
  # Access the current working directory
  aruba.root_directory
  ```

* `cd`: Change directory

  This can be used to change to `cd('path/to/dir')`, but also replaces
  `in_current_directory {}`. Just run `cd('.') {}` and you will have the same
  effect. It also supports nesting `cd('dir1') { cd('dir2') { run('pwd') }`.
  This also changes `ENV['PWD']` and `ENV['OLDPWD']` if invoked with a block.

* `with_environment`: Run code in a changed ENV

    Using the `with_environment`-method you can run code in a changed process
    environment (ENV for rubyists). The environment is changed by using
    `set_environment_variable`, `prepend_environment_variable` and
    `append_environment_variable`. It accepts an `Hash` as argument which is
    only merged within this block.

* `expand_path`: Expand paths

    This expands to the fixtures directory if the given path is prefixed with
    `%`. It also resolves '~'.

**Move assertions/checks to rspec matchers**

More and more `check_*` and `assert_*` methods have been moved to
`RSpec`-matchers. And more will come. Check `lib/aruba/matchers` for more
information about them. For now those matchers should be considered
experimental and maybe they're changed without further notice.

**Move tests to documentation**

We started to migrate more and more tests to living documentation. At one time
in the future we will generate the documentation from that tests.

**Changing environment variables**


