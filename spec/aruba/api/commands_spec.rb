# frozen_string_literal: true

require 'spec_helper'
require 'aruba/api'
require 'fileutils'

RSpec.describe Aruba::Api::Commands, type: :aruba do
  describe '#run_command' do
    context 'when running a globally available command' do
      after { all_commands.each(&:stop) }

      it 'runs the command succesfully' do
        run_command 'echo "Hello"'

        aggregate_failures do
          expect(last_command_started).to be_successfully_executed
          expect(last_command_started).to have_output "Hello\n"
        end
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

  describe '#type' do
    before { run_command 'cat' }

    after { all_commands.each(&:stop) }

    it 'works with unfrozen input' do
      type(+'Hello')
      type(+"\u0004")

      expect(last_command_started).to have_output "Hello\n"
    end

    it 'works with frozen input' do
      type 'Hello'
      type "\u0004"

      expect(last_command_started).to have_output "Hello\n"
    end
  end

  describe '#close_input' do
    after { all_commands.each(&:stop) }

    it 'closes the input stream' do
      run_command 'cat'
      type 'Hello'
      close_input
      expect { type 'Goodbye' }.to raise_error IOError
    end
  end

  describe '#pipe_in_file' do
    after { all_commands.each(&:stop) }

    it 'pipes data' do
      run_command 'cat'
      write_file('test.txt', "Hello\nWorld!")
      pipe_in_file('test.txt')
      close_input
      expect(last_command_started).to have_output "Hello\nWorld!"
    end
  end

  describe '#which' do
    it 'finds a globally available command' do
      expected = if Gem.win_platform?
                   '\\echo.exe'
                 else
                   '/echo'
                 end
      expect(which('echo')).to end_with expected
    end

    it 'does not find a globally available command if path is empty' do
      expect(which('echo', '')).to be_nil
    end

    context 'when looking for a relative command' do
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

      it 'finds the command in the workspace' do
        expect(which(cmd)).to eq expand_path(cmd)
      end

      it 'finds the command even when the path is empty' do
        expect(which(cmd, '')).to eq expand_path(cmd)
      end
    end
  end
end
