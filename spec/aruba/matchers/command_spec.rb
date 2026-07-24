# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Command Matchers', type: :aruba do
  describe '#have_exit_status' do
    let(:cmd) { 'true' }

    before { run_command(cmd) }

    context 'when has exit 0' do
      it { expect(last_command_started).to have_exit_status 0 }
    end

    context 'when does not have exit 0' do
      let(:cmd) { 'false' }

      it { expect(last_command_started).not_to have_exit_status 0 }
    end
  end

  describe '#be_successfully_executed' do
    let(:cmd) { 'true' }

    before { run_command(cmd) }

    context 'when has exit 0' do
      it { expect(last_command_started).to be_successfully_executed }
    end

    context 'when does not have exit 0' do
      let(:cmd) { 'false' }

      it { expect(last_command_started).not_to be_successfully_executed }
    end
  end

  describe '#have_finished_in_time' do
    let(:slow_cmd) { 'sleep 0.2' }
    let(:fast_cmd) { 'true' }

    before { aruba.config.exit_timeout = 0.1 }

    it 'matches for a fast command' do
      run_command(fast_cmd)

      expect(last_command_started).to have_finished_in_time
    end

    it 'matches negatively for a slow command' do
      run_command(slow_cmd)

      expect(last_command_started).not_to have_finished_in_time
    end
  end

  describe '#run_too_long' do
    let(:slow_cmd) { 'sleep 0.2' }
    let(:fast_cmd) { 'true' }

    before { aruba.config.exit_timeout = 0.1 }

    it 'matches negatively for a fast command' do
      run_command(fast_cmd)

      expect(last_command_started).not_to run_too_long
    end

    it 'matches for a slow command' do
      run_command(slow_cmd)

      expect(last_command_started).to run_too_long
    end
  end

  describe '#have_output' do
    let(:cmd) do
      instance_double(Aruba::Processes::SpawnProcess,
                      commandline: 'foo',
                      stop: true)
    end

    before do
      allow(cmd).to receive(:output).and_return(output)
    end

    context 'with a simple one-line output' do
      let(:output) { "hello world\n" }

      it 'succeeds when matching against identical string' do
        expect(cmd).to have_output output
      end

      it 'succeeds when negating match against other string' do
        expect(cmd).not_to have_output "hello universe\n"
      end

      it 'succeeds when negating match against empty string' do
        expect(cmd).not_to have_output ''
      end
    end

    context 'with empty output' do
      let(:output) { '' }

      it 'succeeds when matching against empty string' do
        expect(cmd).to have_output ''
      end
    end

    context 'with output containing ansi escape codes' do
      let(:output) { "\e[36mhello world\e[0m\n" }

      it 'matches with expected string without escape codes' do
        expect(cmd).to have_output "hello world\n"
      end

      it 'does not match with string with escape codes' do
        expect(cmd).not_to have_output "\e[36mhello world\e[0m\n"
      end

      it 'does not match with plain string when ansi codes are kept' do
        aruba.config.remove_ansi_escape_sequences = false
        expect(cmd).not_to have_output "hello world\n"
      end

      it 'matches with string with escape codes when ansi codes are kept' do
        aruba.config.remove_ansi_escape_sequences = false
        expect(cmd).to have_output "\e[36mhello world\e[0m\n"
      end
    end
  end

  describe '#have_output_on_stdout' do
    let(:cmd) do
      instance_double(Aruba::Processes::SpawnProcess,
                      commandline: 'foo',
                      stop: true)
    end

    before do
      allow(cmd).to receive(:stdout).and_return(output)
    end

    context 'with a simple one-line output on stdout' do
      let(:output) { "hello world\n" }

      it 'succeeds when matching against identical string' do
        expect(cmd).to have_output_on_stdout output
      end

      it 'succeeds when negating match against other string' do
        expect(cmd).not_to have_output_on_stdout "hello universe\n"
      end
    end

    context 'with empty output' do
      let(:output) { '' }

      it 'succeeds when matching against empty string' do
        expect(cmd).to have_output_on_stdout ''
      end
    end

    context 'with output containing ansi escape codes on stdout' do
      let(:output) { "\e[36mhello world\e[0m\n" }

      it 'matches with expected string without escape codes' do
        expect(cmd).to have_output_on_stdout "hello world\n"
      end

      it 'does not match with string with escape codes' do
        expect(cmd).not_to have_output_on_stdout "\e[36mhello world\e[0m\n"
      end

      it 'does not match with plain string when ansi codes are kept' do
        aruba.config.remove_ansi_escape_sequences = false
        expect(cmd).not_to have_output_on_stdout "hello world\n"
      end

      it 'matches with string with escape codes when ansi codes are kept' do
        aruba.config.remove_ansi_escape_sequences = false
        expect(cmd).to have_output_on_stdout "\e[36mhello world\e[0m\n"
      end
    end
  end

  describe '#have_output_on_stderr' do
    let(:cmd) do
      instance_double(Aruba::Processes::SpawnProcess,
                      commandline: 'foo',
                      stop: true)
    end

    before do
      allow(cmd).to receive(:stderr).and_return(output)
    end

    context 'with a simple one-line output on stderr' do
      let(:output) { "hello world\n" }

      it 'succeeds when matching against identical string' do
        expect(cmd).to have_output_on_stderr output
      end

      it 'succeeds when negating match against other string' do
        expect(cmd).not_to have_output_on_stderr "hello universe\n"
      end
    end

    context 'with empty output on stderr' do
      let(:output) { '' }

      it 'succeeds when matching against empty string' do
        expect(cmd).to have_output_on_stderr ''
      end
    end

    context 'with output containing ansi escape codes on stderr' do
      let(:output) { "\e[36mhello world\e[0m\n" }

      it 'matches with expected string without escape codes' do
        expect(cmd).to have_output_on_stderr "hello world\n"
      end

      it 'does not match with string with escape codes' do
        expect(cmd).not_to have_output_on_stderr "\e[36mhello world\e[0m\n"
      end

      it 'has negative match with plain string when ansi codes are kept' do
        aruba.config.remove_ansi_escape_sequences = false
        expect(cmd).not_to have_output_on_stderr "hello world\n"
      end

      it 'matches with string with escape codes when ansi codes are kept' do
        aruba.config.remove_ansi_escape_sequences = false
        expect(cmd).to have_output_on_stderr "\e[36mhello world\e[0m\n"
      end
    end
  end

  describe '#have_output_size' do
    context 'when actual is a string' do
      let(:obj) { 'string' }

      before do
        allow(Aruba.platform).to receive(:deprecated)
      end

      it 'matches when the string is the given size' do
        expect(obj).to have_output_size 6
      end

      it 'does not match when the string does not have the given size' do
        expect(obj).not_to have_output_size 5
      end

      it 'emits a deprecation warning' do
        aggregate_failures do
          expect(Aruba.platform).to receive(:deprecated)
          expect(obj).to have_output_size 6
        end
      end
    end

    context 'when actual is a command' do
      let(:cmd) { "echo #{output}" }
      let(:output) { 'hello world' }

      before { run_command(cmd) }

      it 'matches directly on the command itself' do
        expect(last_command_started).to have_output_size "#{output}\n".length
      end

      it 'does not match if output size is different' do
        expect(last_command_started).not_to have_output_size "#{output}\n".length + 1
      end
    end

    context 'when size is zero' do
      let(:cmd) { 'true' }

      before { run_command(cmd) }

      it 'matches directly on the command itself' do
        expect(last_command_started).to have_output_size 0
      end
    end
  end
end
