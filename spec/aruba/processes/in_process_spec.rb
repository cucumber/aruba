require 'spec_helper'

RSpec.describe Aruba::Processes::InProcess do
  class Runner
    def initialize(_argv, _stdin, stdout, stderr, _kernel)
      @stdout = stdout
      @stderr = stderr
    end

    def execute!; end
  end

  class StdoutRunner < Runner
    def execute!
      @stdout.puts 'yo'
    end
  end

  class StderrRunner < Runner
    def execute!
      @stderr.puts 'yo'
    end
  end

  class FailedRunner < Runner
    def execute!
      raise 'Oops'
    end
  end

  subject(:process) do
    described_class.new(command, exit_timeout, io_wait, working_directory,
                        environment, main_class)
  end

  let(:command) { 'foo' }
  let(:exit_timeout) { 1 }
  let(:io_wait) { 1 }
  let(:working_directory) { Dir.getwd }
  let(:environment) { ENV.to_hash.dup }
  let(:main_class) { Runner }

  describe "#stdout" do
    let(:main_class) { StdoutRunner }

    before do
      process.start
      process.stop
    end

    context 'when invoked once' do
      it { expect(process.stdout).to eq "yo\n" }
    end

    context 'when invoked twice' do
      it { 2.times { expect(process.stdout).to eq "yo\n" } }
    end
  end

  describe "#stderr" do
    let(:main_class) { StderrRunner }

    before do
      process.start
      process.stop
    end

    context 'when invoked once' do
      it { expect(process.stderr).to eq "yo\n" }
    end

    context 'when invoked twice' do
      it { 2.times { expect(process.stderr).to eq "yo\n" } }
    end
  end

  describe "#stop" do
    before { process.start }

    context 'when stopped successfully' do
      it { expect { process.stop }.not_to raise_error }

      it 'makes the process stopped' do
        process.stop
        expect(process).to be_stopped
      end
    end
  end

  describe "#start" do
    context "when process run succeeds" do
      it { expect { process.start }.not_to raise_error }

      it 'makes the process started' do
        process.start
        expect(process).to be_started
      end
    end

    context "when process run fails" do
      let(:main_class) { FailedRunner }

      it { expect { process.start }.to raise_error RuntimeError, 'Oops' }
    end
  end
end
