require 'spec_helper'

RSpec.describe Aruba::CommandMonitor do
  subject do
    described_class.new(announcer: announcer)
  end

  let(:announcer) { instance_double(Aruba::Platforms::Announcer) }

  let(:process) { instance_double(Aruba::Processes::BasicProcess) }

  before do
    allow(process).to receive(:commandline).and_return('foobar')
    subject.register_command(process)
  end

  describe "#output_from" do
    it "works" do
      allow(process).to receive(:output).and_return('foo')
      expect(subject.output_from('foobar')).to eq('foo')
    end
  end

  describe "#stdout_from" do
    it "works" do
      allow(process).to receive(:stdout).and_return('foo')
      expect(subject.stdout_from('foobar')).to eq('foo')
    end
  end

  describe "#stderr_from" do
    it "works" do
      allow(process).to receive(:stderr).and_return('foo')
      expect(subject.stderr_from('foobar')).to eq('foo')
    end
  end
end
