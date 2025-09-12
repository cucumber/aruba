# frozen_string_literal: true

require 'spec_helper'
require 'aruba/api'

RSpec.describe 'Aruba JRuby Startup Helper' do
  include Aruba::Api

  let(:rb_config) { instance_double(Hash) }
  let(:command) do
    instance_double(Aruba::Processes::BasicProcess, environment: command_environment)
  end
  let(:command_environment) { { 'JRUBY_OPTS' => '--1.9', 'JAVA_OPTS' => '-Xdebug' } }

  before do
    Aruba.config.reset

    # Define before :command hook
    load 'aruba/config/jruby.rb'
  end

  context 'when running under some MRI Ruby' do
    before do
      stub_const('RUBY_PLATFORM', 'x86_64-chocolate')
    end

    it 'keeps the existing JRUBY_OPTS and JAVA_OPTS environment values' do
      # Run defined before :command hook
      Aruba.config.run_before_hook :command, self, command

      aggregate_failures do
        expect(command_environment['JRUBY_OPTS']).to eq '--1.9'
        expect(command_environment['JAVA_OPTS']).to eq '-Xdebug'
      end
    end
  end

  context 'when running under JRuby but not on Solaris' do
    before do
      unless RUBY_PLATFORM == 'java'
        stub_const 'RUBY_PLATFORM', 'java'
        stub_const 'JRUBY_VERSION', '9.2.0.0'
      end
      stub_const 'RbConfig::CONFIG', rb_config

      allow(rb_config).to receive(:[]).with('host_os').and_return('foo-os')
    end

    it 'updates the existing JRuby but not Java option values' do
      # Run defined before :command hook
      Aruba.config.run_before_hook :command, self, command

      aggregate_failures do
        expect(command_environment['JRUBY_OPTS']).to eq '--dev -X-C --1.9'
        expect(command_environment['JAVA_OPTS']).to eq '-Xdebug'
      end
    end
  end

  context 'when running under JRuby on Solaris' do
    before do
      unless RUBY_PLATFORM == 'java'
        stub_const 'RUBY_PLATFORM', 'java'
        stub_const 'JRUBY_VERSION', '9.2.0.0'
      end
      stub_const 'RbConfig::CONFIG', rb_config

      allow(rb_config).to receive(:[]).with('host_os').and_return('solaris')
    end

    it 'keeps the existing JRuby and Java option values' do
      # Run defined before :command hook
      Aruba.config.run_before_hook :command, self, command

      aggregate_failures do
        expect(command_environment['JRUBY_OPTS']).to eq '--dev -X-C --1.9'
        expect(command_environment['JAVA_OPTS']).to eq '-d32 -Xdebug'
      end
    end
  end
end
