# frozen_string_literal: true

require 'spec_helper'
require 'aruba/api'
require 'fileutils'
require 'time'

describe Aruba::Api do
  include_context 'uses aruba API'

  describe 'tags' do
    describe '@announce_stdout' do
      after { @aruba.all_commands.each(&:stop) }

      context 'enabled' do
        before do
          @aruba.aruba.announcer = instance_double Aruba::Platforms::Announcer
          allow(@aruba.aruba.announcer).to receive(:announce)
        end

        it 'announces to stdout exactly once' do
          expect(@aruba.aruba.announcer).to receive(:announce).with(:stdout).once
          @aruba.run_command_and_stop('echo "hello world"', fail_on_error: false)

          expect(@aruba.last_command_started.output).to include('hello world')
        end
      end

      context 'disabled' do
        it 'does not announce to stdout' do
          result = capture(:stdout) do
            @aruba.run_command_and_stop('echo "hello world"', fail_on_error: false)
          end

          expect(result).not_to include('hello world')
          expect(@aruba.last_command_started.output).to include('hello world')
        end
      end
    end
  end

  describe '#set_environment_variable' do
    let(:get_env_cmd) { FFI::Platform.windows? ? "set" : "env" }

    after do
      @aruba.all_commands.each(&:stop)
    end

    it 'set environment variable' do
      @aruba.set_environment_variable 'LONG_LONG_ENV_VARIABLE', 'true'
      @aruba.run_command_and_stop get_env_cmd
      expect(@aruba.last_command_started.output)
        .to include('LONG_LONG_ENV_VARIABLE=true')
    end

    it 'overwrites environment variable' do
      @aruba.set_environment_variable 'LONG_LONG_ENV_VARIABLE', 'true'
      @aruba.set_environment_variable 'LONG_LONG_ENV_VARIABLE', 'false'
      @aruba.run_command_and_stop get_env_cmd
      expect(@aruba.last_command_started.output)
        .to include('LONG_LONG_ENV_VARIABLE=false')
    end
  end
end
