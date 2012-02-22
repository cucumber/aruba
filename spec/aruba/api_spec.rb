require 'spec_helper'

describe Aruba::Api  do

  before(:each) do
    klass = Class.new {
      include Aruba::Api

      def set_tag(tag_name, value)
        self.instance_variable_set "@#{tag_name.to_s}", value
      end

      def announce_or_puts(*args)
        p caller[0..2]
      end
    }
    @aruba = klass.new

    @file_name = "test.txt"
    @file_size = 256
    @file_path = File.join(@aruba.current_dir, @file_name)
  end

  describe 'current_dir' do
    it "should return the current dir as 'tmp/aruba'" do
      @aruba.current_dir.should match(/^tmp\/aruba$/)
    end
  end

  describe 'files' do
    context 'fixed size' do
      it "should write a fixed sized file" do
        @aruba.write_fixed_size_file(@file_name, @file_size)
        File.exist?(@file_path).should == true
        File.size(@file_path).should == @file_size
      end

      it "should check an existing file size" do
        @aruba.write_fixed_size_file(@file_name, @file_size)
        @aruba.check_file_size([[@file_name, @file_size]])
      end

      it "should check an existing file size and fail" do
        @aruba.write_fixed_size_file(@file_name, @file_size)
        lambda { @aruba.check_file_size([[@file_name, @file_size + 1]]) }.should raise_error
      end
    end
  end

  describe 'tags' do
    describe '@announce_stdout' do

      context 'enabled' do
        it "should announce to stdout exactly once" do
          @aruba.should_receive(:announce_or_puts).once
          @aruba.set_tag(:announce_stdout, true)
          @aruba.run_simple("ruby -e 'puts \"hello world\"'", false)
          @aruba.all_output.should match(/hello world/)
        end
      end

      context 'disabled' do
        it "should not announce to stdout" do
          @aruba.should_not_receive(:announce_or_puts)
          @aruba.set_tag(:announce_stdout, false)
          @aruba.run_simple("ruby -e 'puts \"hello world\"'", false)
          @aruba.all_output.should match(/hello world/)
        end
      end
    end
  end

  describe "#check_file_content" do
    before :each do
      @aruba.write_file(@file_name, "foo bar baz")
    end

    it "checks the file's content against the partial content" do
      @aruba.check_file_content(@file_name, /foo/, true)
      @aruba.check_file_content(@file_name, /zoo/, false)
    end

    context "doing true/false assertions and tests within the block" do
      it "checks the file's content by the given block" do
        @aruba.check_file_content(@file_name, true) do |content|
          content =~ /foo/
        end

        @aruba.check_file_content(@file_name, false) do |content|
          content =~ /zoo/
        end

        expect do
          @aruba.check_file_content(@file_name, true) do |content|
            content =~ /zoo/
          end
        end .to raise_error RSpec::Expectations::ExpectationNotMetError
      end
    end

    context "using a matcher within the block" do
      it "follows the block's inner assertion logic" do
        @aruba.check_file_content(@file_name, true) do |content|
          content.match(/(foo)/)[1].should == "foo"
        end

        expect do
          @aruba.check_file_content(@file_name, false) do |content|
            content.match(/(foo)/)[1].should == "zoo"
          end
        end .to raise_error RSpec::Expectations::ExpectationNotMetError

        expect do
          @aruba.check_file_content(@file_name, true) do |content|
            content.match(/(foo)/)[1].should == "zoo"
          end
        end .to raise_error RSpec::Expectations::ExpectationNotMetError

        expect do
          @aruba.check_file_content(@file_name, true) do |content|
            content.match(/(foo)/)[1].should_not == "zoo"
          end
        end .to raise_error RSpec::Expectations::ExpectationNotMetError
      end
    end

    it "raises an ArgumentError when given neither partial_content nor block" do
      expect {@aruba.check_file_content(@file_name, true)}.to raise_error(ArgumentError)
    end

    it "raises an ArgumentError when given both partial_content and block" do
      expect {@aruba.check_file_content(@file_name, /zoo/, true) {|c| true } }.to raise_error(ArgumentError)
    end


  end
end
