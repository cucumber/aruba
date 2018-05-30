require 'spec_helper'

RSpec.describe 'Command Matchers' do
  include_context 'uses aruba API'

  def expand_path(*args)
    @aruba.expand_path(*args)
  end

  def announcer(*args)
    @aruba.send(:announcer, *args)
  end

  describe '#to_have_exit_status' do
    let(:cmd) { 'true' }

    before(:each) { run_command(cmd) }

    context 'when has exit 0' do
      it { expect(last_command_started).to have_exit_status 0 }
    end

    context 'when has exit 0' do
      let(:cmd) { 'false' }
      it { expect(last_command_started).not_to have_exit_status 0 }
    end
  end

  describe '#to_be_successfully_executed_' do
    let(:cmd) { 'true' }

    before(:each) { run_command(cmd) }

    context 'when has exit 0' do
      it { expect(last_command_started).to be_successfully_executed }
    end

    context 'when has exit 0' do
      let(:cmd) { 'false' }
      it { expect(last_command_started).not_to be_successfully_executed }
    end
  end

  describe '#to_have_output' do
    let(:cmd) { "echo #{output}" }
    let(:output) { 'hello world' }

    context 'when have output hello world on stdout' do
      before(:each) { run_command(cmd) }
      it { expect(last_command_started).to have_output output }
    end

    context 'when multiple commands output hello world on stdout' do
      context 'and all comands must have the output' do
        before(:each) do
          run_command(cmd)
          run_command(cmd)
        end

        it { expect(all_commands).to all have_output output }
      end

      context 'and any comand can have the output' do
        before(:each) do
          run_command(cmd)
          run_command('echo hello universe')
        end

        it { expect(all_commands).to include have_output(output) }
      end
    end

    context 'when have output hello world on stderr' do
      let(:cmd) { "ruby -e 'warn \"#{output}\"'" }

      before(:each) { run_command(cmd) }

      it { expect(last_command_started).to have_output output }
    end

    context 'when not has output' do
      before(:each) { run_command(cmd) }

      it { expect(last_command_started).not_to have_output 'hello universe' }
    end
  end

  describe '#to_have_output_on_stdout' do
    let(:cmd) { "echo #{output}" }
    let(:output) { 'hello world' }

    context 'when have output hello world on stdout' do
      before(:each) { run_command(cmd) }
      it { expect(last_command_started).to have_output_on_stdout output }
    end

    context 'when have output hello world on stderr' do
      let(:cmd) { "ruby -e 'warn \"#{output}\"'" }

      before(:each) { run_command(cmd) }

      it { expect(last_command_started).not_to have_output_on_stdout output }
    end

    context 'when not has output' do
      before(:each) { run_command(cmd) }

      it { expect(last_command_started).not_to have_output_on_stdout 'hello universe' }
    end
  end

  describe '#to_have_output_on_stderr' do
    let(:cmd) { "echo #{output}" }
    let(:output) { 'hello world' }

    context 'when have output hello world on stdout' do
      before(:each) { run_command(cmd) }
      it { expect(last_command_started).not_to have_output_on_stderr output }
    end

    context 'when have output hello world on stderr' do
      let(:cmd) { "ruby -e 'warn \"#{output}\"'" }

      before(:each) { run_command(cmd) }

      it { expect(last_command_started).to have_output_on_stderr output }
    end

    context 'when not has output' do
      before(:each) { run_command(cmd) }

      it { expect(last_command_started).not_to have_output_on_stderr 'hello universe' }
    end
  end
end
