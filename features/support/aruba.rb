require 'aruba/cucumber'

Aruba.configure do |config|
  config.exit_timeout    = 120
  config.io_wait_timeout = 2
end
