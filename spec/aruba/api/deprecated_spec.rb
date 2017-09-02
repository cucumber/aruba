require 'spec_helper'

if Aruba::VERSION <= '1.1.0'
  RSpec.describe 'Deprecated API' do
    include_context 'uses aruba API'

    around do |example|
      Aruba.platform.with_environment do
        example.run
      end
    end

    let(:monitor) { instance_double(Aruba::CommandMonitor) }

    before do
      allow(@aruba.aruba).to receive(:command_monitor).and_return(monitor)
      allow(Aruba.platform).to receive(:deprecated)
    end

    describe "#output_from" do
      it "works" do
        allow(monitor).to receive(:stdout_from).with('foobar').and_return("foo")
        expect(@aruba.stdout_from('foobar')).to eq('foo')
      end
    end

    describe "#stdout_from" do
      it "works" do
        allow(monitor).to receive(:stdout_from).with('foobar').and_return("foo")
        expect(@aruba.stdout_from('foobar')).to eq('foo')
      end
    end

    describe "#stderr_from" do
      it "works" do
        allow(monitor).to receive(:stderr_from).with('foobar').and_return("foo")
        expect(@aruba.stderr_from('foobar')).to eq('foo')
      end
    end
  end
end
