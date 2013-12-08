require 'aruba/spawn_process'

module Aruba
  describe SpawnProcess do

    let(:process) { SpawnProcess.new('echo "yo"', 0.1, 0.1) }

    describe "#stdout" do
      before { process.run! }

      it "returns the stdout" do
        expect(process.stdout).to eq "yo\n"
      end

      it "returns all the stdout, every time you call it" do
        expect(process.stdout).to eq "yo\n"
        expect(process.stdout).to eq "yo\n"
      end

    end

    describe "#stop" do
      before { process.run! }

      it "sends any output to the reader" do
        reader = double( 'null_object' )
        allow( reader ).to receive( :stderr )
        expect( reader ).to receive( :stdout ).with("yo\n")

        process.stop(reader)
      end
    end

    describe "#run!" do
      context "upon process launch error" do
        let(:process_failure) { SpawnProcess.new('does_not_exists', 1, 1) }

        it "raises a Aruba::LaunchError" do
          expect{process_failure.run!}.to raise_error(::Aruba::LaunchError)
        end
      end
    end

  end
end
