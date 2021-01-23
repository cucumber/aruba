require 'spec_helper'

RSpec.describe Aruba::Processes::SpawnProcess do
  subject(:process) do
    described_class.new(command_line, exit_timeout, io_wait, working_directory)
  end

  let(:command_line) { 'echo "yo"' }
  let(:exit_timeout) { 30 }
  let(:io_wait) { 1 }
  let(:working_directory) { Dir.getwd }

  describe '#stdout' do
    before do
      process.start
      process.stop
    end

    context 'when invoked once' do
      it { expect(process.stdout.chomp).to eq 'yo' }
    end

    context 'when invoked twice' do
      it { 2.times { expect(process.stdout.chomp).to eq 'yo' } }
    end
  end

  describe '#stderr' do
    let(:command_line) { "sh -c \"echo 'yo' >&2\"" }

    before do
      process.start
      process.stop
    end

    it 'returns the output of the process on stderr' do
      expect(process).not_to be_timed_out
      expect(process.stderr.chomp).to eq 'yo'
    end

    it 'returns the same result when invoked a second time' do
      2.times { expect(process.stderr.chomp).to eq 'yo' }
    end
  end

  describe '#write' do
    let(:command_line) { "ruby -e 'puts gets'" }

    it 'writes single strings to the process' do
      process.start
      process.write "hello\n"
      process.stop

      expect(process.stdout).to eq "hello\n"
    end

    it 'writes multiple strings to the process' do
      process.start
      process.write 'hel', "lo\n"
      process.stop

      expect(process.stdout).to eq "hello\n"
    end
  end

  describe '#stop' do
    before { process.start }

    context 'when stopped successfully' do
      it { expect { process.stop }.not_to raise_error }

      it 'makes the process stopped' do
        process.stop
        expect(process).to be_stopped
      end
    end
  end

  describe '#start' do
    context 'when process run succeeds' do
      it { expect { process.start }.not_to raise_error }

      it 'makes the process started' do
        process.start
        expect(process).to be_started
      end
    end

    context 'when process run fails' do
      let(:command_line) { 'does_not_exists' }

      it { expect { process.start }.to raise_error Aruba::LaunchError }
    end

    context 'when on unix' do
      let(:child) { instance_double(ChildProcess::AbstractProcess).as_null_object }
      let(:io) { instance_double(ChildProcess::AbstractIO).as_null_object }
      let(:command_line) { 'foo' }
      let(:command) { 'foo' }
      let(:command_path) { '/bar/foo' }

      before do
        allow(Aruba.platform).to receive(:command_string)
          .and_return Aruba::Platforms::UnixCommandString
        allow(Aruba.platform)
          .to receive(:which).with(command, anything).and_return(command_path)
        allow(ChildProcess).to receive(:build).and_return(child)

        allow(child).to receive(:io).and_return(io)
        allow(child).to receive(:environment).and_return({})
      end

      context 'with a childprocess launch error' do
        before do
          allow(child).to receive(:start).and_raise(ChildProcess::LaunchError, 'Foobar!')
        end

        it "reraises LaunchError as Aruba's LaunchError" do
          expect { process.start }
            .to raise_error(Aruba::LaunchError, "It tried to start #{command}. Foobar!")
        end
      end

      context 'with a command with a space in the path' do
        let(:command_path) { '/path with space/foo' }

        before do
          allow(Aruba.platform).to receive(:command_string)
            .and_return Aruba::Platforms::UnixCommandString
          allow(Aruba.platform)
            .to receive(:which).with(command, anything).and_return(command_path)
          allow(ChildProcess).to receive(:build).with(command_path).and_return(child)
          allow(child).to receive(:io).and_return io
          allow(child).to receive(:environment).and_return({})
        end

        it 'passes the command path as a single string to ChildProcess.build' do
          process.start
          expect(ChildProcess).to have_received(:build).with(command_path)
        end
      end

      context 'with a command with arguments' do
        let(:command_line) { 'foo -x "bar baz"' }

        it 'passes the command and arguments as separate items to ChildProcess.build' do
          process.start
          expect(ChildProcess).to have_received(:build)
            .with(command_path, '-x', 'bar baz')
        end
      end
    end

    context 'when on windows' do
      let(:child) { instance_double(ChildProcess::AbstractProcess).as_null_object }
      let(:io) { instance_double(ChildProcess::AbstractIO).as_null_object }
      let(:command_line) { 'foo' }
      let(:command) { 'foo' }
      let(:cmd_path) { 'C:\Bar\cmd.exe' }
      let(:command_path) { 'D:\Foo\foo' }

      before do
        allow(Aruba.platform).to receive(:command_string)
          .and_return Aruba::Platforms::WindowsCommandString
        allow(Aruba.platform).to receive(:which).with('cmd.exe').and_return(cmd_path)
        allow(Aruba.platform)
          .to receive(:which).with(command, anything).and_return(command_path)
        allow(ChildProcess).to receive(:build).and_return(child)

        allow(child).to receive(:io).and_return(io)
        allow(child).to receive(:environment).and_return({})
      end

      context 'with a childprocess launch error' do
        before do
          allow(child).to receive(:start).and_raise(ChildProcess::LaunchError, 'Foobar!')
        end

        it "reraises LaunchError as Aruba's LaunchError" do
          expect { process.start }
            .to raise_error(Aruba::LaunchError, "It tried to start #{command}. Foobar!")
        end
      end

      context 'with a command without a space in the path' do
        it 'passes the command and shell paths as single strings to ChildProcess.build' do
          process.start
          expect(ChildProcess).to have_received(:build).with(cmd_path, '/c', command_path)
        end
      end

      context 'with a command with a space in the path' do
        let(:command_path) { 'D:\Bar Baz\foo' }

        it 'escapes the spaces using excessive double quotes' do
          process.start
          expect(ChildProcess)
            .to have_received(:build).with(cmd_path, '/c', 'D:\Bar""" """Baz\foo')
        end
      end

      context 'with a command with arguments' do
        let(:command_line) { "foo -x 'bar \"baz\"'" }

        it 'passes the command and arguments as one string with escaped quotes' do
          process.start
          expect(ChildProcess).to have_received(:build)
            .with(cmd_path, '/c', "#{command_path} -x \"bar \"\"\"baz\"\"\"\"")
        end
      end
    end
  end

  describe '#command' do
    let(:command_line) { "ruby -e 'warn \"yo\"'" }

    it 'returns the first item of the command line' do
      expect(process.command).to eq 'ruby'
    end
  end

  describe '#arguments' do
    let(:command_line) { "ruby -e 'warn \"yo\"'" }

    it 'handles arguments delimited with quotes' do
      expect(process.arguments).to eq ['-e', 'warn "yo"']
    end
  end
end
