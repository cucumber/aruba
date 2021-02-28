# @note this file is loaded in env.rb to setup simplecov using RUBYOPTs for
# child processes and @in-process
unless RUBY_PLATFORM.include?("java")
  begin
    require "simplecov"
    root = File.expand_path("../..", __dir__)
    SimpleCov.command_name(ENV["SIMPLECOV_COMMAND_NAME"])
    SimpleCov.root(root)
    load File.join(root, ".simplecov")
  rescue LoadError
    # skip
  end
end
