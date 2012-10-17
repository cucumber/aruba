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

    (@aruba.dirs.length-1).times do |depth| #Ensure all parent dirs exists
      dir = File.join(*@aruba.dirs[0..depth])
      Dir.mkdir(dir) unless File.exist?(dir)
    end
    raise "We must work with relative paths, everything else is dangerous" if ?/ == @aruba.current_dir[0]
    FileUtils.rm_rf(@aruba.current_dir)
    Dir.mkdir(@aruba.current_dir)
  end

  describe 'current_dir' do
    it "should return the current dir as 'tmp/aruba'" do
      @aruba.current_dir.should match(/^tmp\/aruba$/)
    end
  end

  describe 'directories' do
    context 'delete directory' do
      before(:each) do
        @directory_name = 'test_dir'
        @directory_path = File.join(@aruba.current_dir, @directory_name)
        Dir.mkdir(@directory_path)
      end
      it 'should delete directory' do
        @aruba.remove_dir(@directory_name)
        File.exist?(@directory_path).should == false
      end
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
    context 'existing' do
      before(:each) { File.open(@file_path, 'w') { |f| f << "" } }
      it "should delete file" do
        @aruba.remove_file(@file_name)
        File.exist?(@file_path).should == false
      end
    end
  end

  describe 'tags' do
    describe '@announce_stdout' do
      after(:each){@aruba.stop_processes!}
      context 'enabled' do
        it "should announce to stdout exactly once" do
          @aruba.should_receive(:announce_or_puts).once
          @aruba.set_tag(:announce_stdout, true)
          @aruba.run_simple('echo "hello world"', false)
          @aruba.all_output.should match(/hello world/)
        end
      end

      context 'disabled' do
        it "should not announce to stdout" do
          @aruba.should_not_receive(:announce_or_puts)
          @aruba.set_tag(:announce_stdout, false)
          @aruba.run_simple('echo "hello world"', false)
          @aruba.all_output.should match(/hello world/)
        end
      end
    end
  end

  describe "#with_file_content" do
    before :each do
      @aruba.write_file(@file_name, "foo bar baz")
    end

    it "checks the given file's full content against the expectations in the passed block" do
       @aruba.with_file_content @file_name do |full_content|
         full_content.should == "foo bar baz"
       end
    end

    context "checking the file's content against the expectations in the block" do
      it "is successful when the inner expectations match" do
        expect do
          @aruba.with_file_content @file_name do |full_content|
            full_content.should     match /foo/
            full_content.should_not match /zoo/
          end
        end . not_to raise_error RSpec::Expectations::ExpectationNotMetError
      end

      it "raises RSpec::Expectations::ExpectationNotMetError when the inner expectations don't match"  do
        expect do
          @aruba.with_file_content @file_name do |full_content|
            full_content.should     match /zoo/
            full_content.should_not match /foo/
          end
        end . to raise_error RSpec::Expectations::ExpectationNotMetError
      end
    end

  end #with_file_content

  describe "#assert_not_matching_output" do
    before(:each){ @aruba.run_simple("echo foo", false) }
    after(:each){ @aruba.stop_processes! }

    it "passes when the output doesn't match a regexp" do
      @aruba.assert_not_matching_output "bar", @aruba.all_output
    end
    it "fails when the output does match a regexp" do
      expect do
        @aruba.assert_not_matching_output "foo", @aruba.all_output
      end . to raise_error RSpec::Expectations::ExpectationNotMetError
    end
  end

  describe "#run_interactive" do
    before(:each){@aruba.run_interactive "cat"}
    after(:each){@aruba.stop_processes!}
    it "respond to input" do
      @aruba.type "Hello"
      @aruba.type ""
      @aruba.all_output.should == "Hello\n"
    end

    it "respond to eot" do
      @aruba.type "Hello"
      @aruba.eot
      @aruba.all_output.should == "Hello\n"
    end
  end

end # Aruba::Api
