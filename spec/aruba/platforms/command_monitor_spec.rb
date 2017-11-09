require 'spec_helper'

RSpec.describe Aruba::CommandMonitor do
  subject do
    described_class.new(:announcer => announcer)
  end

  let(:announcer) { instance_double(Aruba::Platforms::Announcer) }

  let(:process) { instance_double(Aruba::Processes::BasicProcess) }

  before do
    allow(process).to receive(:commandline).and_return('foobar')
    subject.register_command(process)
  end

  describe "#find" do
    it "works" do
      expect(subject.find('foobar')).to eq(process)
    end
  end
end
