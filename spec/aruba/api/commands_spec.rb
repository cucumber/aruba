require 'spec_helper'
require 'aruba/api'
require 'fileutils'

RSpec.describe Aruba::Api::Commands do
  include_context 'uses aruba API'

  describe '#run_command' do
    context 'when succesfully running a command' do
      before { @aruba.run_command 'cat' }

      after { @aruba.all_commands.each(&:stop) }

      it 'respond to input' do
        @aruba.type 'Hello'
        @aruba.type "\u0004"
        expect(@aruba.last_command_started).to have_output 'Hello'
      end

      it 'respond to close_input' do
        @aruba.type 'Hello'
        @aruba.close_input
        expect(@aruba.last_command_started).to have_output 'Hello'
      end

      it 'pipes data' do
        @aruba.write_file(@file_name, "Hello\nWorld!")
        @aruba.pipe_in_file(@file_name)
        @aruba.close_input
        expect(@aruba.last_command_started).to have_output "Hello\nWorld!"
      end
    end

    context 'when mode is :in_process' do
      before do
        @aruba.aruba.config.command_launcher = :in_process
      end

      after do
        @aruba.aruba.config.command_launcher = :spawn
      end

      it 'raises an error' do
        expect { @aruba.run_command 'cat' }.to raise_error NotImplementedError
      end
    end

    context 'when running a relative command' do
      let(:cmd) { Cucumber::WINDOWS ? 'bin/testcmd.bat' : 'bin/testcmd' }

      before do
        if Cucumber::WINDOWS
          @aruba.write_file cmd, <<~BAT
            exit 0
          BAT
        else
          @aruba.write_file cmd, <<~BASH
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
