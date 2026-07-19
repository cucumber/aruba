# frozen_string_literal: true

require 'spec_helper'
require 'aruba/api'
require 'fileutils'

RSpec.describe Aruba::Api::Commands, type: :aruba do
  include_context 'uses aruba API'

  describe '#run_command' do
    context 'when succesfully running a command' do
      before { run_command 'cat' }

      after { all_commands.each(&:stop) }

      it 'respond to unfrozen input' do
        type(+'Hello')
        type(+"\u0004")

        expect(last_command_started).to have_output "Hello\n"
      end

      it 'respond to frozen input' do
        type 'Hello'
        type "\u0004"

        expect(last_command_started).to have_output "Hello\n"
      end

      it 'respond to close_input' do
        type 'Hello'
        close_input
        expect(last_command_started).to have_output "Hello\n"
      end

      it 'pipes data' do
        write_file(@file_name, "Hello\nWorld!")
        pipe_in_file(@file_name)
        close_input
        expect(last_command_started).to have_output "Hello\nWorld!"
      end
    end

    context 'when mode is :in_process' do
      before do
        aruba.config.command_launcher = :in_process
      end

      after do
        aruba.config.command_launcher = :spawn
      end

      it 'raises an error' do
        expect { run_command 'cat' }.to raise_error NotImplementedError
      end
    end

    context 'when running a relative command' do
      let(:cmd) { Gem.win_platform? ? 'bin/testcmd.bat' : 'bin/testcmd' }

      before do
        if Gem.win_platform?
          write_file cmd, <<~BAT
            exit 0
          BAT
        else
          write_file cmd, <<~BASH
            #!/bin/bash
            exit 0
          BASH
          chmod 0o755, cmd
        end
      end

      it 'finds the command from the test directory' do
        run_command(cmd)
        expect(last_command_started).to be_successfully_executed
      end
    end
  end
end
