require "spec_helper"

RSpec.describe Aruba::Processes::SpawnProcess do
  subject(:process) do
    described_class.new(command_line, exit_timeout, io_wait, working_directory)
  end

  include_context "uses aruba API"

  let(:command_line) { 'echo "yo"' }
  let(:exit_timeout) { 30 }
  let(:io_wait) { 1 }
  let(:working_directory) { @aruba.expand_path(".") }

  describe "#stdout" do
    context "with a command that is stopped" do
      before do
        process.start
        process.stop
      end

      context "when invoked once" do
        it { expect(process.stdout.chomp).to eq "yo" }
      end

      context "when invoked twice" do
        it { 2.times { expect(process.stdout.chomp).to eq "yo" } }
      end
    end

    context "with a command that is still running" do
      let(:cmd) { "bin/test-cli" }
      let(:command_line) { "bash bin/test-cli" }
      let(:exit_timeout) { 0.1 }

      before do
        @aruba.write_file cmd, <<~BASH
          #!/usr/bin/env bash

          echo "yo"
          sleep 1
          exit 0
        BASH
      end

      it "returns the output so far" do
        process.start
        expect(process.stdout.chomp).to eq "yo"
        process.stop
      end
    end
  end

  describe "#stderr" do
    context "with a command that is stopped" do
      let(:command_line) { "sh -c \"echo 'yo' >&2\"" }

      before do
        process.start
        process.stop
      end

      it "returns the output of the process on stderr" do
        expect(process).not_to be_timed_out
        expect(process.stderr.chomp).to eq "yo"
      end

      it "returns the same result when invoked a second time" do
        2.times { expect(process.stderr.chomp).to eq "yo" }
      end
    end

    context "with a command that is still running" do
      let(:cmd) { "bin/test-cli" }
      let(:command_line) { "bash bin/test-cli" }
      let(:exit_timeout) { 0.1 }

      before do
        @aruba.write_file cmd, <<~BASH
          #!/usr/bin/env bash

          echo "yo" >&2
          sleep 1
          exit 0
        BASH
      end

      it "returns the error output so far" do
        process.start
        expect(process.stderr.chomp).to eq "yo"
        process.stop
      end
    end
  end

  describe "#stop" do
    context "when stopped successfully" do
      before do
        process.start
      end

      it { expect { process.stop }.not_to raise_error }

      it "makes the process stopped" do
        process.stop
        expect(process).to be_stopped
      end
    end

    context "with a command that is taking a long time to run" do
      let(:cmd) { "bin/test-cli" }
      let(:command_line) { "bash bin/test-cli" }
      let(:exit_timeout) { 0.1 }

      before do
        @aruba.write_file cmd, <<~BASH
          #!/usr/bin/env bash

          sleep 5
          echo "Success"
          exit 0
        BASH
      end

      it "terminates the command" do
        process.start
        process.stop
        expect(process).not_to have_output "Success"
      end
    end
  end

  describe "#start" do
    context "when process run succeeds" do
      it { expect { process.start }.not_to raise_error }

      it "makes the process started" do
        process.start
        expect(process).to be_started
      end

      it "raises an error when attempting to start twice" do
        process.start

        expect { process.start }.to raise_error Aruba::CommandAlreadyStartedError
      end
    end

    context "when process run fails" do
      let(:command_line) { "does_not_exists" }

      it { expect { process.start }.to raise_error Aruba::LaunchError }
    end

    context "when on unix" do
      let(:child) { instance_double(Aruba::Processes::ProcessRunner).as_null_object }
      let(:command_line) { "foo" }
      let(:command) { "foo" }
      let(:command_path) { "/bar/foo" }

      before do
        allow(Aruba.platform).to receive(:command_string)
          .and_return Aruba::Platforms::UnixCommandString
        allow(Aruba.platform)
          .to receive(:which).with(command, anything).and_return(command_path)
        allow(Aruba::Processes::ProcessRunner).to receive(:new).and_return(child)

        allow(child).to receive(:environment).and_return({})
      end

      context "when spawning raises some SystemCallError" do
        let(:error) { Errno::ENOENT.new "Foobar!" }

        before do
          allow(child).to receive(:start).and_raise error
        end

        it "reraises as Aruba's LaunchError" do
          expect { process.start }
            .to raise_error(Aruba::LaunchError,
                            "It tried to start #{command}. #{error.message}")
        end
      end

      context "with a command with a space in the path" do
        let(:command_path) { "/path with space/foo" }

        it "passes the command path as a single string to ProcessRunner.new" do
          process.start
          expect(Aruba::Processes::ProcessRunner).to have_received(:new).with([command_path])
        end
      end

      context "with a command with arguments" do
        let(:command_line) { 'foo -x "bar baz"' }

        it "passes the command and arguments as separate items to ProcessRunner.new" do
          process.start
          expect(Aruba::Processes::ProcessRunner).to have_received(:new)
            .with([command_path, "-x", "bar baz"])
        end
      end
    end

    context "when on windows" do
      let(:child) { instance_double(Aruba::Processes::ProcessRunner).as_null_object }
      let(:command_line) { "foo" }
      let(:command) { "foo" }
      let(:cmd_path) { 'C:\Bar\cmd.exe' }
      let(:command_path) { 'D:\Foo\foo' }

      before do
        allow(Aruba.platform).to receive(:command_string)
          .and_return Aruba::Platforms::WindowsCommandString
        allow(Aruba.platform).to receive(:which).with("cmd.exe").and_return(cmd_path)
        allow(Aruba.platform)
          .to receive(:which).with(command, anything).and_return(command_path)
        allow(Aruba::Processes::ProcessRunner).to receive(:new).and_return(child)

        allow(child).to receive(:environment).and_return({})
      end

      context "when spawning raises some SystemCallError" do
        let(:error) { Errno::ENOENT.new "Foobar!" }

        before do
          allow(child).to receive(:start).and_raise error
        end

        it "reraises as Aruba's LaunchError" do
          expect { process.start }
            .to raise_error(Aruba::LaunchError,
                            "It tried to start #{command}. #{error.message}")
        end
      end

      context "with a command without a space in the path" do
        it "passes the command and shell paths as single strings to ProcessRunner.new" do
          process.start
          expect(Aruba::Processes::ProcessRunner).to have_received(:new)
            .with([cmd_path, "/c", command_path])
        end
      end

      context "with a command with a space in the path" do
        let(:command_path) { 'D:\Bar Baz\foo' }

        it "escapes the spaces using excessive double quotes" do
          process.start
          expect(Aruba::Processes::ProcessRunner).to have_received(:new)
            .with([cmd_path, "/c", 'D:\Bar""" """Baz\foo'])
        end
      end

      context "with a command with arguments" do
        let(:command_line) { "foo -x 'bar \"baz\"'" }

        it "passes the command and arguments as one string with escaped quotes" do
          process.start
          expect(Aruba::Processes::ProcessRunner).to have_received(:new)
            .with([cmd_path, "/c", "#{command_path} -x \"bar \"\"\"baz\"\"\"\""])
        end
      end
    end
  end

  describe "#send_signal" do
    let(:signal) { Gem.win_platform? ? 9 : "KILL" }

    context "with a command that is running" do
      let(:cmd) { "bin/test-cli" }
      let(:command_line) { "bash bin/test-cli" }

      before do
        @aruba.write_file cmd, <<~BASH
          #!/usr/bin/env bash

          sleep 5
          echo "Success"
          exit 0
        BASH
      end

      it "sends the given signal to the command" do
        process.start
        process.send_signal signal
        process.stop
        expect(process).not_to have_output "Success"
      end
    end

    context "with a command that has stopped" do
      it "raises an error" do
        process.start
        process.stop

        expect { process.send_signal signal }
          .to raise_error Aruba::CommandAlreadyStoppedError
      end
    end
  end

  describe "#command" do
    let(:command_line) { "ruby -e 'warn \"yo\"'" }

    it "returns the first item of the command line" do
      expect(process.command).to eq "ruby"
    end
  end

  describe "#arguments" do
    let(:command_line) { "ruby -e 'warn \"yo\"'" }

    it "handles arguments delimited with quotes" do
      expect(process.arguments).to eq ["-e", 'warn "yo"']
    end
  end
end
