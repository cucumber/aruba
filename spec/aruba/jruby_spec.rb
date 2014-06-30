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
      expect(ENV['JRUBY_OPTS']).to eq "--1.9"
      expect(ENV['JAVA_OPTS']).to eq "-Xdebug"
    end
  end

  it 'configuration loads for java and merges existing environment variables' do
    with_constants :ENV => @fake_env, :RUBY_PLATFORM => 'java'  do
      rb_config = double('rb_config')
      allow(rb_config).to receive(:[]).and_return('solaris')
      stub_const 'RbConfig::CONFIG', rb_config

      load 'aruba/jruby.rb'
      Aruba.config.hooks.execute :before_cmd, self
      expect(ENV['JRUBY_OPTS']).to eq "-X-C --1.9"
      expect(ENV['JAVA_OPTS']).to eq "-d32 -Xdebug"
    end
  end
end
