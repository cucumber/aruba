require 'aruba/processes/spawn_process'

RSpec.describe Aruba::Processes::SpawnProcess do
  subject(:process) { described_class.new(command, exit_timeout, io_wait, working_directory, environment, main_class) }

  let(:command) { 'echo "yo"' }
  let(:exit_timeout) { 1 }
  let(:io_wait) { 1 }
  let(:working_directory) { Dir.getwd }
  let(:environment) { ENV.to_hash.dup }
  let(:main_class) { nil }

  describe "#stdout" do
    before(:each) { process.start }
    before(:each) { process.stop }

    context 'when invoked once' do
      it { expect(process.stdout).to eq "yo\n" }
    end

    context 'when invoked twice' do
      it { 2.times { expect(process.stdout).to eq "yo\n" } }
    end
  end

  describe "#stderr" do
    let(:command) { 'fixtures/spawn_process/stderr.sh yo' }

    before(:each) { process.start }
    before(:each) { process.stop }

    context 'when invoked once' do
      it { expect(process.stderr).to eq "yo\n" }
    end

    context 'when invoked twice' do
      it { 2.times { expect(process.stderr).to eq "yo\n" } }
    end
  end

  describe "#stop" do
    before(:each) { process.start }

    context 'when stopped successfully' do
      it { process.stop }
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

    context "with a childprocess launch error" do
      let(:child) { instance_double(ChildProcess::AbstractProcess) }
      let(:command) { 'foo' }

      before do
        allow(ChildProcess).to receive(:build).and_return(child)

        # STEP 1: Simlulate the program exists (but will fail to run, e.g. EACCESS?)
        allow(Aruba.platform).to receive(:which).with(command, anything).and_return("/foo")

        # STEP 2: Simulate the failure on Windows
        allow(child).to receive(:start).and_raise(ChildProcess::LaunchError, "Foobar!")

        # TODO: wrap the result of ChildProcess.build with a special Aruba
        # class , so the remaining mocks below won't be needed
        allow(child).to receive(:leader=)

        io = instance_double(ChildProcess::AbstractIO)
        allow(io).to receive(:stdout=)
        allow(io).to receive(:stderr=)

        allow(child).to receive(:io).and_return(io)

        allow(child).to receive(:duplex=)
        allow(child).to receive(:cwd=)

        allow(child).to receive(:environment).and_return({})
      end

      it "reraises LaunchError as Aruba's LaunchError" do
        expect { process.start }.to raise_error(Aruba::LaunchError, "It tried to start foo. Foobar!")
      end
    end
  end
end
