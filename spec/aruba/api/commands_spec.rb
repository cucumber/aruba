# frozen_string_literal: true

require 'spec_helper'
require 'aruba/api'
require 'fileutils'

RSpec.describe Aruba::Api::Commands do
  include_context 'uses aruba API'

  describe '#run_command' do
    let(:cmd) { 'ruby -ne "puts $_"' }

    context 'when successfully running a command' do
      before { @aruba.run_command cmd }

      after { @aruba.all_commands.each(&:stop) }

      it 'respond to unfrozen input' do
        @aruba.type(+'Hello')
        @aruba.type(+"\u0004")

        expect(@aruba.last_command_started).to have_output('Hello')
      end

      it 'respond to frozen input' do
        @aruba.type 'Hello'
        @aruba.type "\u0004"

        expect(@aruba.last_command_started).to have_output('Hello')
      end

      it 'respond to close_input' do
        @aruba.type 'Hello'
        @aruba.close_input
        expect(@aruba.last_command_started).to have_output('Hello')
      end

      # TODO: This may need some support and/or disabling for windows when introduced
      # See https://github.com/cucumber/aruba/pull/505/files#r207702697 for details
      it 'pipes data' do
        @aruba.write_file(@file_name, "Hello\nWorld!")
        @aruba.pipe_in_file(@file_name)
        @aruba.close_input
        expect(@aruba.last_command_started).to have_output("Hello\nWorld!")
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
        expect { @aruba.run_command cmd }.to raise_error NotImplementedError
      end
    end

    context 'when running a relative command' do
      let(:cmd) { Gem.win_platform? ? 'bin/testcmd.bat' : 'bin/testcmd' }

      before do
        if Gem.win_platform?
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
