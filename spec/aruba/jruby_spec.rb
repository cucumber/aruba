require 'spec_helper'
require 'aruba/api'

describe "Aruba JRuby Startup Helper" do
  before(:all) do
    @fake_env = ENV.clone
  end

  before :each do
    Aruba.config.reset

    # Define before_cmd-hook
    load 'aruba/config/jruby.rb'
  end

  before(:each) do
    @fake_env['JRUBY_OPTS'] = "--1.9"
    @fake_env['JAVA_OPTS'] = "-Xdebug"

    stub_const('ENV', @fake_env)
  end

  context 'when some mri ruby' do
    before :each do
      stub_const('RUBY_PLATFORM', 'x86_64-chocolate')
    end

    before :each do
      Aruba.config.before :command, self
    end

    it { expect(ENV['JRUBY_OPTS']).to eq '--1.9' }
    it { expect(ENV['JAVA_OPTS']).to eq '-Xdebug' }
  end

  context 'when jruby ruby' do
    before :each do
      stub_const('RUBY_PLATFORM', 'java')
    end

    before :each do
      rb_config = double('rb_config')
      allow(rb_config).to receive(:[]).and_return('solaris')

      stub_const 'RbConfig::CONFIG', rb_config
    end

    before :each do
      Aruba.config.before :command, self
    end

    it { expect(ENV['JRUBY_OPTS']).to eq '--dev -X-C --1.9' }
    it { expect(ENV['JAVA_OPTS']).to eq '-d32 -Xdebug' }
  end
end
