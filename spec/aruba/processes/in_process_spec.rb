require 'spec_helper'

RSpec.describe Aruba::Processes::InProcess do
  let(:base_runner) do
    Class.new do
      def initialize(_argv, _stdin, stdout, stderr, kernel)
        @stdout = stdout
        @stderr = stderr
        @kernel = kernel
      end

      def execute!; end
    end
  end

  let(:stdout_runner) do
    Class.new(base_runner) do
      def execute!
        @stdout.puts 'yo'
      end
    end
  end

  let(:stderr_runner) do
    Class.new(base_runner) do
      def execute!
        @stderr.puts 'yo'
      end
    end
  end

  let(:stdin_runner) do
    Class.new(base_runner) do
      def execute!
        @stdin.rewind
        item = @stdin.gets.to_s.chomp
        @stdout.puts "Hello, #{item}!"
      end
    end
  end

  let(:failed_runner) do
    Class.new(base_runner) do
      def execute!
        raise 'Oops'
      end
    end
  end

  let(:process) do
    described_class.new(command, exit_timeout, io_wait, working_directory,
                        environment, main_class)
  end

  let(:command) { 'foo' }
  let(:exit_timeout) { 1 }
  let(:io_wait) { 1 }
  let(:working_directory) { Dir.getwd }
  let(:environment) { ENV.to_hash.dup }
  let(:main_class) { base_runner }

  describe '#stdout' do
    let(:main_class) { stdout_runner }

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

  describe '#stderr' do
    let(:main_class) { stderr_runner }

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
      let(:main_class) { failed_runner }

      it { expect { process.start }.to raise_error RuntimeError, 'Oops' }
    end
  end

  describe '#exit_status' do
    def run_process(&block)
      process = described_class.new(
        command, exit_timeout, io_wait, working_directory,
        environment, Class.new(base_runner) { define_method(:execute!, &block) }
      )
      process.start
      process.stop
      process
    end

    it 'exits success' do
      expect(run_process { nil }.exit_status).to eq 0
    end

    it 'exits with given status' do
      expect(run_process { @kernel.exit 12 }.exit_status).to eq 12
    end

    it 'exits with boolean' do
      expect(run_process { @kernel.exit false }.exit_status).to eq 1
    end

    it 'refuses to exit with anything else' do
      expect { run_process { @kernel.exit 'false' } }
        .to raise_error(TypeError, 'no implicit conversion of String into Integer')
    end
  end

  describe '#write' do
    let(:main_class) { stdin_runner }

    it 'writes single strings to the process' do
      process.write 'World'
      process.start
      process.stop
      expect(process.stdout).to eq "Hello, World!\n"
    end

    it 'writes multiple strings to the process' do
      process.write 'Wor', 'ld'
      process.start
      process.stop
      expect(process.stdout).to eq "Hello, World!\n"
    end
  end
end
