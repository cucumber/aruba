require 'spec_helper'
require 'aruba/config'
require 'aruba/api'
include Aruba::Api

describe "Aruba JRuby Startup Helper"  do
  before(:all) do
    @fake_env = ENV.clone
  end
  before(:each) do
    Aruba.config = Aruba::Config.new
    @fake_env['JRUBY_OPTS'] = "--1.9"
    @fake_env['JAVA_OPTS'] = "-Xdebug"
  end

  it 'configuration does not load when RUBY_PLATFORM is not java' do
    with_constants :ENV => @fake_env, :RUBY_PLATFORM => 'x86_64-chocolate' do
      load 'aruba/jruby.rb'
      Aruba.config.hooks.execute :before_cmd, self
      ENV['JRUBY_OPTS'].should  == "--1.9"
      ENV['JAVA_OPTS'].should  == "-Xdebug"
    end
  end

  it 'configuration loads for java and merges existing environment variables' do
    with_constants :ENV => @fake_env, :RUBY_PLATFORM => 'java'  do
      RbConfig::CONFIG.stub(:[] => 'solaris')
      load 'aruba/jruby.rb'
      Aruba.config.hooks.execute :before_cmd, self
      ENV['JRUBY_OPTS'].should  == "-X-C --1.9"
      ENV['JAVA_OPTS'].should  == "-d32 -Xdebug"
    end 
  end
end
