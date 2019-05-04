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
      it { expect { process.stop }.not_to raise_error }

      it "leaves the process in the 'stopped' state" do
        process.stop
        aggregate_failures do
          expect(process).to be_stopped
          expect(process).not_to be_started
        end
      end
    end
  end

  describe "#start" do
    context "when process run succeeds" do
      it { expect { process.start }.not_to raise_error }

      it "leaves the process in the 'started' state" do
        process.start
        aggregate_failures do
          expect(process).to be_started
          expect(process).not_to be_stopped
        end
      end
    end

    context "when process run fails" do
      let(:command) { 'does_not_exists' }

      it { expect { process.start }.to raise_error Aruba::LaunchError }
    end

    context 'with a command with a space in the path on unix' do
      let(:child) { instance_double(ChildProcess::AbstractProcess).as_null_object }
      let(:io) { instance_double(ChildProcess::AbstractIO).as_null_object }
      let(:command) { 'foo' }
      let(:command_path) { '/path with space/foo' }

      before do
        allow(Aruba.platform).to receive(:command_string).and_return Aruba::Platforms::UnixCommandString
        allow(Aruba.platform).to receive(:which).with(command, anything).and_return(command_path)
        allow(ChildProcess).to receive(:build).with(command_path).and_return(child)
        allow(child).to receive(:io).and_return io
        allow(child).to receive(:environment).and_return({})
      end

      it { expect { process.start }.to_not raise_error }
    end

    context 'with a command with a space in the path on windows' do
      let(:child) { instance_double(ChildProcess::AbstractProcess).as_null_object }
      let(:io) { instance_double(ChildProcess::AbstractIO).as_null_object }
      let(:command) { 'foo' }
      let(:cmd_path) { 'C:\Some Path\cmd.exe' }
      let(:command_path) { 'D:\Bar Baz\foo' }

      before do
        allow(Aruba.platform).to receive(:command_string).and_return Aruba::Platforms::WindowsCommandString
        allow(Aruba.platform).to receive(:which).with('cmd.exe').and_return(cmd_path)
        allow(Aruba.platform).to receive(:which).with(command, anything).and_return(command_path)
        allow(ChildProcess).to receive(:build).with(cmd_path, '/c', command_path).and_return(child)
        allow(child).to receive(:io).and_return io
        allow(child).to receive(:environment).and_return({})
      end

      it { expect { process.start }.to_not raise_error }
    end
  end
end
