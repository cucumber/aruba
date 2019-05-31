require 'aruba/rspec'
require 'aruba/config/jruby'

Aruba.configure do |config|
  config.activate_announcer_on_command_failure = [:stderr, :stdout, :command]
end
