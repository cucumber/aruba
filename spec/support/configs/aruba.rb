require 'aruba/rspec'

Aruba.configure do |config|
  config.activate_announcer_on_command_failure = [:stderr, :stdout, :command]
end
