require 'aruba/process'

module Aruba
  describe Process do

    let(:process) { Process.new('echo "yo"', 0, 0.1) }

    describe "#stdout" do
      before { process.run! }

      it "returns the stdout" do
        process.stdout(false).should == "yo\n"
      end

      it "returns all the stdout, every time you call it" do
        process.stdout(false).should == "yo\n"
        process.stdout(false).should == "yo\n"
      end

    end

    describe "#stop" do
      before { process.run! }

      it "sends any output to the reader" do
        reader = stub.as_null_object
        reader.should_receive(:stdout).with("yo\n")
        process.stop(reader, false)
      end
    end

  end
end
