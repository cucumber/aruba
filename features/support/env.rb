$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')
require 'aruba'

begin
  # rspec-2
  require 'rspec/expectations'
rescue LoadError
  # rspec-1
  require 'spec/expectations'
end
