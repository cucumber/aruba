require 'spec_helper'

RSpec.describe Aruba::Processes::SpawnProcess do
  subject(:process) { described_class.new(command, exit_timeout, io_wait, working_directory) }

  let(:command) { 'echo "yo"' }
  let(:exit_timeout) { 1 }
  let(:io_wait) { 1 }
  let(:working_directory) { Dir.getwd }

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
      let(:command) { 'does_not_exists' }

      it { expect { process.start }.to raise_error Aruba::LaunchError }
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
