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
      expect(@aruba.current_dir).to match(/^tmp\/aruba$/)
    end

    it "can be cleared" do
      write_file( 'test', 'test test test' )

      in_current_dir do
        expect( File.exist? 'test' ).to be_truthy
      end

      clean_current_dir

      in_current_dir do
        expect( File.exist? 'test' ).to be_falsey
      end

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
        expect(File.exist?(@directory_path)).to eq false
      end
    end
  end

  describe 'files' do
    context 'fixed size' do
      it "should write a fixed sized file" do
        @aruba.write_fixed_size_file(@file_name, @file_size)
        expect(File.exist?(@file_path)).to eq true
        expect(File.size(@file_path)).to eq @file_size
      end

      it "should check an existing file size" do
        @aruba.write_fixed_size_file(@file_name, @file_size)
        @aruba.check_file_size([[@file_name, @file_size]])
      end

      it "should check an existing file size and fail" do
        @aruba.write_fixed_size_file(@file_name, @file_size)
        expect { @aruba.check_file_size([[@file_name, @file_size + 1]]) }.to raise_error
      end
    end
    context 'existing' do
      before(:each) { File.open(@file_path, 'w') { |f| f << "" } }
      it "should delete file" do
        @aruba.remove_file(@file_name)
        expect(File.exist?(@file_path)).to eq false
      end

      it "should change a file's mode" do
        @aruba.chmod(0644, @file_name)
        result = sprintf( "%o" , File::Stat.new(@file_path).mode )[-4,4]
        expect(result).to eq('0644')

        @aruba.chmod(0655, @file_name)
        result = sprintf( "%o" , File::Stat.new(@file_path).mode )[-4,4]
        expect(result).to eq('0655')

        @aruba.chmod("0655", @file_name)
        result = sprintf( "%o" , File::Stat.new(@file_path).mode )[-4,4]
        expect(result).to eq('0655')
      end

      it "should check the mode of a file" do
        @aruba.chmod(0666, @file_name)
        expect(@aruba.mod?(0666, @file_name) ).to eq(true)
      end

      it "should check existence using plain match" do
        file_name = 'nested/dir/hello_world.txt'
        file_path = File.join(@aruba.current_dir, file_name)

        FileUtils.mkdir_p File.dirname( file_path )
        File.open(file_path, 'w') { |f| f << "" }

        @aruba.check_file_presence( [ file_name ], true )
        @aruba.check_file_presence( [ 'asdf' ] , false )
      end

      it "should check existence using regex" do
        file_name = 'nested/dir/hello_world.txt'
        file_path = File.join(@aruba.current_dir, file_name)

        FileUtils.mkdir_p File.dirname( file_path )
        File.open(file_path, 'w') { |f| f << "" }

        @aruba.check_file_presence([ /test123/ ], false )
        @aruba.check_file_presence([ /hello_world.txt$/ ], true )
        @aruba.check_file_presence([ /dir/ ], true )
        @aruba.check_file_presence([ %r{nested/.+/} ], true )
      end

      it "is no problem to mix both" do
        file_name = 'nested/dir/hello_world.txt'
        file_path = File.join(@aruba.current_dir, file_name)

        FileUtils.mkdir_p File.dirname( file_path )
        File.open(file_path, 'w') { |f| f << "" }

        @aruba.check_file_presence([ file_name, /nested/  ], true )
        @aruba.check_file_presence([ /test123/, 'asdf' ], false )
      end

    end
  end

  describe 'tags' do
    describe '@announce_stdout' do
      after(:each){@aruba.stop_processes!}
      context 'enabled' do
        it "should announce to stdout exactly once" do
          expect(@aruba).to receive(:announce_or_puts).once
          @aruba.set_tag(:announce_stdout, true)
          @aruba.run_simple('echo "hello world"', false)
          expect(@aruba.all_output).to match(/hello world/)
        end
      end

      context 'disabled' do
        it "should not announce to stdout" do
          expect(@aruba).not_to receive(:announce_or_puts)
          @aruba.set_tag(:announce_stdout, false)
          @aruba.run_simple('echo "hello world"', false)
          expect(@aruba.all_output).to match(/hello world/)
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
         expect(full_content).to eq "foo bar baz"
       end
    end

    context "checking the file's content against the expectations in the block" do
      it "is successful when the inner expectations match" do
        expect do
          @aruba.with_file_content @file_name do |full_content|
            expect(full_content).to     match /foo/
            expect(full_content).not_to match /zoo/
          end
        end . not_to raise_error
      end

      it "raises RSpec::Expectations::ExpectationNotMetError when the inner expectations don't match"  do
        expect do
          @aruba.with_file_content @file_name do |full_content|
            expect(full_content).to     match /zoo/
            expect(full_content).not_to match /foo/
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
      expect(@aruba.all_output).to eq  "Hello\n"
    end

    it "respond to close_input" do
      @aruba.type "Hello"
      @aruba.close_input
      expect(@aruba.all_output).to eq  "Hello\n"
    end

    it "pipes data" do
      @aruba.write_file(@file_name, "Hello\nWorld!")
      @aruba.pipe_in_file(@file_name)
      @aruba.close_input
      expect(@aruba.all_output).to eq  "Hello\nWorld!"
    end
  end

  describe "#run_simple" do
    before(:each){@aruba.run_simple "true"}
    after(:each){@aruba.stop_processes!}
    describe "get_process" do
      it "returns a process" do
        expect(@aruba.get_process("true")).not_to be(nil)
      end

      it "raises a descriptive exception" do
        expect do
          expect(@aruba.get_process("false")).not_to be(nil)
        end.to raise_error(ArgumentError, "No process named 'false' has been started")
      end
    end
  end

  describe "#run_simple" do
    after(:each){@aruba.stop_processes!}
    it "runs with different env" do
      @aruba.set_env 'LONG_LONG_ENV_VARIABLE', 'true'
      @aruba.run "env"
      expect(@aruba.all_output).to include("LONG_LONG_ENV_VARIABLE")
    end

  end

end # Aruba::Api
