require 'spec_helper'

describe Aruba::Api  do

  before(:each) do
    klass = Class.new {
      include Aruba::Api

      def announce=(value)
        @announce_stdout = value
      end
    }
    @aruba = klass.new
  end

  describe 'current_dir' do
    it "should return the current dir as 'tmp/aruba'" do
      @aruba.current_dir.should match(/^tmp\/aruba$/)
    end
  end

  describe 'run' do

    context 'with the @announce_stdout tag' do
      it "should announce to stdout exactly once" do
        @aruba.should_receive(:announce_or_puts).once
        @aruba.announce = true
        @aruba.run("ruby -e 'puts \"hello world\"'")
        @aruba.all_output.should match(/hello world/)
      end
    end

    context 'without @announce_stdout tag' do
      it "should not announce to stdout" do
        @aruba.should_not_receive(:announce_or_puts)
        @aruba.announce = false
        @aruba.run("ruby -e 'puts \"hello world\"'")
        @aruba.all_output.should match(/hello world/)
      end
    end

  end
end
