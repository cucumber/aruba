# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Command Matchers' do
  include_context 'uses aruba API'

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
    let(:slow_cmd) { 'sleep 0.3' }
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
    let(:cmd) { "echo #{output}" }
    let(:output) { 'hello world' }

    context 'when have output hello world on stdout' do
      before { run_command(cmd) }

      it { expect(last_command_started).to have_output output }
    end

    context 'when multiple commands output hello world on stdout' do
      context 'and all commands must have the output' do
        before do
          run_command(cmd)
          run_command(cmd)
        end

        it { expect(all_commands).to all have_output output }
      end

      context 'and any command can have the output' do
        before do
          run_command(cmd)
          run_command('echo hello universe')
        end

        it { expect(all_commands).to include have_output(output) }
      end
    end

    context 'when have output hello world on stderr' do
      let(:cmd) { "sh -c \"echo #{output} >&2\"" }

      before { run_command(cmd) }

      it { expect(last_command_started).to have_output output }
    end

    context 'when not has output' do
      before { run_command(cmd) }

      it { expect(last_command_started).not_to have_output 'hello universe' }
    end

    context 'when has empty output' do
      before { run_command('false') }

      it { expect(last_command_started).to have_output '' }
    end

    context 'when not has empty output' do
      before { run_command(cmd) }

      it { expect(last_command_started).not_to have_output '' }
    end
  end

  describe '#have_output_on_stdout' do
    let(:cmd) { "echo #{output}" }
    let(:output) { 'hello world' }

    context 'when have output hello world on stdout' do
      before { run_command(cmd) }

      it { expect(last_command_started).to have_output_on_stdout output }
    end

    context 'when have output hello world on stderr' do
      let(:cmd) { "sh -c \"echo #{output} >&2\"" }

      before { run_command(cmd) }

      it { expect(last_command_started).not_to have_output_on_stdout output }
    end

    context 'when not has output' do
      before { run_command(cmd) }

      it { expect(last_command_started).not_to have_output_on_stdout 'hello universe' }
    end
  end

  describe '#have_output_on_stderr' do
    let(:cmd) { "echo #{output}" }
    let(:output) { 'hello world' }

    context 'when have output hello world on stdout' do
      before { run_command(cmd) }

      it { expect(last_command_started).not_to have_output_on_stderr output }
    end

    context 'when have output hello world on stderr' do
      let(:cmd) { "sh -c \"echo #{output} >&2\"" }

      before { run_command(cmd) }

      it { expect(last_command_started).to have_output_on_stderr output }
    end

    context 'when not has output' do
      before { run_command(cmd) }

      it { expect(last_command_started).not_to have_output_on_stderr 'hello universe' }
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
