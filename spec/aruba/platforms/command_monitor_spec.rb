require "spec_helper"

RSpec.describe Aruba::CommandMonitor do
  let(:monitor) { described_class.new(announcer: announcer) }
  let(:announcer) { instance_double(Aruba::Platforms::Announcer) }
  let(:process) { instance_double(Aruba::Processes::BasicProcess, commandline: "foobar") }

  before do
    monitor.register_command(process)
  end

  describe "#find" do
    it "find the process with the given name" do
      expect(monitor.find("foobar")).to eq process
    end

    it "fails if no process with the given name exists" do
      expect { monitor.find("boofar") }.to raise_error Aruba::CommandNotFoundError
    end
  end
end
