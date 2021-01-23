require 'spec_helper'

RSpec.describe Aruba::Processes::BasicProcess do
  let(:cmd) { 'foobar' }
  let(:exit_timeout) { 0 }
  let(:io_wait_timeout) { 0 }
  let(:working_directory) { Dir.pwd }
  let(:process) { described_class.new(cmd, exit_timeout, io_wait_timeout, working_directory) }

  describe '#inspect' do
    let(:stdout) { 'foo output' }
    let(:stderr) { 'foo error output' }

    let(:derived_process) do
      Class.new(described_class) do
        def initialize(*args)
          @stdout = args.shift
          @stderr = args.shift
          super(*args)
        end

        def stdout(*_args)
          @stdout
        end

        def stderr(*_args)
          @stderr
        end
      end.new(stdout, stderr, cmd, exit_timeout, io_wait_timeout, working_directory)
    end

    it 'shows useful info' do
      expected = /commandline="foobar": stdout="foo output" stderr="foo error output"/
      expect(derived_process.inspect).to match(expected)
    end

    context 'with no stdout' do
      let(:stdout) { nil }

      it 'shows useful info' do
        expected = /commandline="foobar": stdout=nil stderr="foo error output"/
        expect(derived_process.inspect).to match(expected)
      end
    end

    context 'with no stderr' do
      let(:stderr) { nil }

      it 'shows useful info' do
        expected = /commandline="foobar": stdout="foo output" stderr=nil/
        expect(derived_process.inspect).to match(expected)
      end
    end

    context 'with neither stderr nor stdout' do
      let(:stderr) { nil }
      let(:stdout) { nil }

      it 'shows useful info' do
        expected = /commandline="foobar": stdout=nil stderr=nil/
        expect(derived_process.inspect).to match(expected)
      end
    end
  end

  describe '#stdin' do
    it 'raises NotImplementedError' do
      expect { process.stdin }.to raise_error NotImplementedError
    end
  end

  describe '#stdout' do
    it 'raises NotImplementedError' do
      expect { process.stdout }.to raise_error NotImplementedError
    end
  end

  describe '#stderr' do
    it 'raises NotImplementedError' do
      expect { process.stderr }.to raise_error NotImplementedError
    end
  end
end
