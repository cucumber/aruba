# frozen_string_literal: true

require 'spec_helper'
require 'aruba/api'
require 'fileutils'
require 'time'

RSpec.describe Aruba::Api, type: :aruba do
  describe 'tags' do
    describe '@announce_stdout' do
      after { all_commands.each(&:stop) }

      context 'enabled' do
        before do
          allow(aruba.announcer).to receive(:announce)
        end

        it 'announces to stdout exactly once' do
          expect(aruba.announcer).to receive(:announce).with(:stdout).once
          run_command_and_stop('echo "hello world"', fail_on_error: false)

          expect(last_command_started.output).to include('hello world')
        end
      end

      context 'disabled' do
        it 'does not announce to stdout' do
          aggregate_failures do
            expect { run_command_and_stop('echo "hello world"', fail_on_error: false) }
              .not_to output('hello world').to_stdout
            expect(last_command_started.output).to include('hello world')
          end
        end
      end
    end
  end

  describe '#set_environment_variable' do
    after do
      all_commands.each(&:stop)
    end

    it 'set environment variable' do
      set_environment_variable 'LONG_LONG_ENV_VARIABLE', 'true'
      run_command_and_stop 'env'
      expect(last_command_started.output)
        .to include('LONG_LONG_ENV_VARIABLE=true')
    end

    it 'overwrites environment variable' do
      set_environment_variable 'LONG_LONG_ENV_VARIABLE', 'true'
      set_environment_variable 'LONG_LONG_ENV_VARIABLE', 'false'
      run_command_and_stop 'env'
      expect(last_command_started.output)
        .to include('LONG_LONG_ENV_VARIABLE=false')
    end
  end
end
