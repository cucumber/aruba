require 'aruba/processes/spawn_process'

RSpec.describe Aruba::Processes::SpawnProcess do
  subject(:process) { described_class.new(command, exit_timeout, io_wait, working_directory) }

  let(:command) { 'echo "yo"' }
  let(:exit_timeout) { 1 }
  let(:io_wait) { 1 }
  let(:working_directory) { Dir.getwd }

  describe "#stdout" do
    before(:each) { process.start }

    context 'when invoked once' do
      it { expect(process.stdout).to eq "yo\n" }
    end

    context 'when invoked twice' do
      it { 2.times { expect(process.stdout).to eq "yo\n" } }
    end
  end

  describe "#stderr" do
    let(:command) { 'features/fixtures/spawn_process/stderr.sh yo' }

    before(:each) { process.start }

    context 'when invoked once' do
      it { expect(process.stderr).to eq "yo\n" }
    end

    context 'when invoked twice' do
      it { 2.times { expect(process.stderr).to eq "yo\n" } }
    end
  end

  describe "#stop" do
    context 'when started' do
      before(:each) { process.start }
      before(:each) { process.stop }

      it { expect(process).to be_stopped }
    end

    context 'when long running process' do

    end
  end

  describe "#start" do
    context "when process run succeeds" do
      it { expect { process.start }.not_to raise_error }
    end

    context "when process run fails" do
      let(:command) { 'does_not_exists' }

      it { expect {process.start}.to raise_error Aruba::LaunchError }
    end
  end
end
