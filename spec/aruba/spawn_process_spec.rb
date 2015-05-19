require 'aruba/processes/spawn_process'

describe Aruba::Processes::SpawnProcess do
  subject(:process) { described_class.new(command, exit_timeout, io_wait, working_directory) }

  let(:command) { 'echo "yo"' }
  let(:exit_timeout) { 1 }
  let(:io_wait) { 1 }
  let(:working_directory) { Dir.getwd }

  describe "#stdout" do
    before(:each) { process.run! }

    context 'when invoked once' do
      it { expect(process.stdout).to eq "yo\n" }
    end

    context 'when invoked twice' do
      it { 2.times { expect(process.stdout).to eq "yo\n" } }
    end
  end

  describe "#stderr" do
    let(:command) { 'features/fixtures/spawn_process/stderr.sh yo' }

    before(:each) { process.run! }

    context 'when invoked once' do
      it { expect(process.stderr).to eq "yo\n" }
    end

    context 'when invoked twice' do
      it { 2.times { expect(process.stderr).to eq "yo\n" } }
    end
  end

  describe "#stop" do
    let(:reader) { double('reader') }

    before(:each) { process.run! }

    before :each do
      allow(reader).to receive(:stderr)
      expect(reader).to receive(:stdout).with("yo\n")
    end

    context 'when stopped successfully' do
      it { process.stop(reader) }
    end
  end

  describe "#run!" do
    context "when process run succeeds" do
      it { expect { process.run! }.not_to raise_error }
    end

    context "when process run fails" do
      let(:command) { 'does_not_exists' }

      it { expect {process.run!}.to raise_error Aruba::LaunchError }
    end
  end
end
