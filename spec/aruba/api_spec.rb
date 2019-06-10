require 'spec_helper'
require 'aruba/api'
require 'fileutils'
require 'time'

describe Aruba::Api do
  include_context 'uses aruba API'

  describe 'tags' do
    describe '@announce_stdout' do
      after(:each) { @aruba.all_commands.each(&:stop) }

      context 'enabled' do
        before :each do
          @aruba.aruba.announcer = instance_double 'Aruba::Platforms::Announcer'
          expect(@aruba.aruba.announcer).to receive(:announce).with(:stdout) { "hello world\n" }
          allow(@aruba.aruba.announcer).to receive(:announce)
        end

        it "should announce to stdout exactly once" do
          @aruba.run_command_and_stop('echo "hello world"')
          expect(@aruba.last_command_started.output).to include('hello world')
        end
      end

      context 'disabled' do
        it "should not announce to stdout" do
          result = capture(:stdout) do
            @aruba.run_command_and_stop('echo "hello world"')
          end

          expect(result).not_to include('hello world')
          expect(@aruba.last_command_started.output).to include('hello world')
        end
      end
    end
  end

  describe 'fixtures' do
    let(:api) do
      klass = Class.new do
        include Aruba::Api

        def root_directory
          expand_path('.')
        end
      end

      klass.new
    end
  end

  describe "#set_environment_variable" do
    after(:each) do
      @aruba.all_commands.each(&:stop)
    end

    it "set environment variable" do
      @aruba.set_environment_variable 'LONG_LONG_ENV_VARIABLE', 'true'
      @aruba.run_command_and_stop "env"
      expect(@aruba.last_command_started.output).
        to include("LONG_LONG_ENV_VARIABLE=true")
    end

    it "overwrites environment variable" do
      @aruba.set_environment_variable 'LONG_LONG_ENV_VARIABLE', 'true'
      @aruba.set_environment_variable 'LONG_LONG_ENV_VARIABLE', 'false'
      @aruba.run_command_and_stop "env"
      expect(@aruba.last_command_started.output).
        to include("LONG_LONG_ENV_VARIABLE=false")
    end
  end
end # Aruba::Api
