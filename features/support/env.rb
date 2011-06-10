$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')
require 'aruba/cucumber'
require 'fileutils'
require 'rspec/expectations'

if(ENV['HTML_SNAPSHOT'])
  require 'aruba/html_snapshot'
  $aruba_snapshot_parent = File.expand_path(File.dirname(__FILE__) + '/../../doc')
end
