# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Aruba::CommandMonitor do
  let(:monitor) { described_class.new(announcer: announcer) }
  let(:announcer) { instance_double(Aruba::Platforms::Announcer) }
  let(:foo_process) do
    instance_double(Aruba::Processes::InProcess, commandline: 'foo',
                                                 stop: nil,
                                                 stdout: "foo_stdout\n",
                                                 stderr: "foo_stderr\n")
  end
  let(:bar_process) do
    instance_double(Aruba::Processes::InProcess, commandline: 'bar',
                                                 stop: nil,
                                                 stdout: "bar_stdout\n",
                                                 stderr: "bar_stderr\n")
  end

  before do
    monitor.register_command(foo_process)
    monitor.register_command(bar_process)
  end

  describe '#find' do
    it 'find the process with the given name' do
      expect(monitor.find('foo')).to eq foo_process
    end

    it 'fails if no process with the given name exists' do
      expect { monitor.find('boofar') }.to raise_error Aruba::CommandNotFoundError
    end
  end

  describe '#all_stdout' do
    it 'combines stdout from all registered processs' do
      expect(monitor.all_stdout).to eq "foo_stdout\nbar_stdout\n"
    end
  end

  describe '#all_stderr' do
    it 'combines stderr from all registered processs' do
      expect(monitor.all_stderr).to eq "foo_stderr\nbar_stderr\n"
    end
  end

  describe '#all_output' do
    it 'combines stdout and stderr from all registered processs' do
      expect(monitor.all_output)
        .to eq "foo_stdout\nbar_stdout\nfoo_stderr\nbar_stderr\n"
    end
  end
end
