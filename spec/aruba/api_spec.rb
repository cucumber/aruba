require 'spec_helper'
require 'securerandom'

describe Aruba::Api  do

  def random_string(options = {})
    options[:prefix].to_s + SecureRandom.hex + options[:suffix].to_s
  end

  before(:each) do
    klass = Class.new {
      include Aruba::Api

      def set_tag(tag_name, value)
        self.instance_variable_set "@#{tag_name}", value
      end

      def announce_or_puts(*args)
        p caller[0..2]
      end
    }
    @aruba = klass.new

    @file_name = "test.txt"
    @file_size = 256
    @file_path = File.join(@aruba.current_dir, @file_name)

    (@aruba.dirs.length - 1).times do |depth| #Ensure all parent dirs exists
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
      write_file('test', 'test test test')

      in_current_dir do
        expect(File.exist?('test')).to be_truthy
      end

      clean_current_dir

      in_current_dir do
        expect(File.exist?('test')).to be_falsey
      end

    end
  end

  describe 'directories' do
    before(:each) do
      @directory_name = 'test_dir'
      @directory_path = File.join(@aruba.current_dir, @directory_name)
    end

    context '#create_dir' do
      it 'creates a directory' do
        @aruba.create_dir @directory_name
        expect(File.exist?(File.expand_path(@directory_path))).to be_truthy
      end
    end

    context '#remove_dir' do
      before :each do
        Dir.mkdir(@directory_path)
      end

      it 'should delete directory' do
        @aruba.remove_dir(@directory_name)
        expect(File.exist?(@directory_path)).to eq false
      end

      it "works with ~ in path name" do
        directory_path = File.join('~', random_string)

        with_env 'HOME' => File.expand_path(current_dir) do
          Dir.mkdir(File.expand_path(directory_path))
          @aruba.remove_dir(directory_path)

          expect(File.exist?(File.expand_path(directory_path))).to eq false
        end
      end
    end
  end

  describe 'files' do
    context '#touch_file' do
      it 'creates an empty file' do
        @aruba.touch_file(@file_name)
        expect(File.exist?(@file_path)).to eq true
        expect(File.size(@file_path)).to eq 0
      end

      it 'supports an unexisting directory in path' do
        path = 'directory/test'
        full_path = File.join(@aruba.current_dir, path)
        @aruba.touch_file(path)

        expect(File.exist?(full_path)).to eq true
      end

      it "works with ~ in path name" do
        file_path = File.join('~', random_string)

        with_env 'HOME' => File.expand_path(current_dir) do
          @aruba.touch_file(file_path)
          expect(File.exist?(File.expand_path(file_path))).to eq true
        end
      end
    end

    context '#absolute_path' do
      it 'expands and returns path' do
        expect(@aruba.absolute_path(@file_name)).to eq File.expand_path(@file_path)
      end

      it 'removes "."' do
        expect(@aruba.absolute_path('.')).to eq File.expand_path(current_dir)
      end

      it 'removes ".."' do
        expect(@aruba.absolute_path('..')).to eq File.expand_path(File.join(current_dir, '..'))
      end

      it 'joins multiple arguments' do
        expect(@aruba.absolute_path('path', @file_name)).to eq File.expand_path(File.join(current_dir, 'path', @file_name))
      end
    end

    context '#write_file' do
      it 'writes file' do
        @aruba.write_file(@file_name, '')

        expect(File.exist?(@file_path)).to eq true
      end
    end

    context '#write_fixed_size_file' do
      it "should write a fixed sized file" do
        @aruba.write_fixed_size_file(@file_name, @file_size)
        expect(File.exist?(@file_path)).to eq true
        expect(File.size(@file_path)).to eq @file_size
      end

      it "works with ~ in path name" do
        file_path = File.join('~', random_string)

        with_env 'HOME' => File.expand_path(current_dir) do
          @aruba.write_fixed_size_file(file_path, @file_size)

          expect(File.exist?(File.expand_path(file_path))).to eq true
          expect(File.size(File.expand_path(file_path))).to eq @file_size
        end
      end
    end

    context '#check_file_size' do
      it "should check an existing file size" do
        @aruba.write_fixed_size_file(@file_name, @file_size)
        @aruba.check_file_size([[@file_name, @file_size]])
      end

      it "should check an existing file size and fail" do
        @aruba.write_fixed_size_file(@file_name, @file_size)
        expect { @aruba.check_file_size([[@file_name, @file_size + 1]]) }.to raise_error
      end

      it "works with ~ in path name" do
        file_path = File.join('~', random_string)

        with_env 'HOME' => File.expand_path(current_dir) do
          @aruba.write_fixed_size_file(file_path, @file_size)
          @aruba.check_file_size([[file_path, @file_size]])
        end
      end

      it "should check an existing file size and fail" do
        @aruba.write_fixed_size_file(@file_name, @file_size)
        expect { @aruba.check_file_size([[@file_name, @file_size + 1]]) }.to raise_error
      end
    end

    context '#filesystem_permissions' do
      before(:each) { File.open(@file_path, 'w') { |f| f << "" } }

      it "should change a file's mode" do
        @aruba.filesystem_permissions(0644, @file_name)
        result = sprintf( "%o" , File::Stat.new(@file_path).mode )[-4,4]
        expect(result).to eq('0644')

        @aruba.filesystem_permissions(0655, @file_name)
        result = sprintf( "%o" , File::Stat.new(@file_path).mode )[-4,4]
        expect(result).to eq('0655')

        @aruba.filesystem_permissions("0655", @file_name)
        result = sprintf( "%o" , File::Stat.new(@file_path).mode )[-4,4]
        expect(result).to eq('0655')
      end

      it "supports a string representation of permission as well" do
        @aruba.filesystem_permissions(0666, @file_name)
        @aruba.check_filesystem_permissions('0666', @file_name, true)
      end

      it "should succeed if mode does not match but is expected to be different" do
        @aruba.filesystem_permissions(0666, @file_name)
        @aruba.check_filesystem_permissions(0755, @file_name, false)
      end

      it "should fail if mode matches and is expected to be different" do
        @aruba.filesystem_permissions(0666, @file_name)
        expect {
          @aruba.check_filesystem_permissions(0666, @file_name, false)
        }.to raise_error
      end

      it "should fail if mode does not match but is expected to be equal" do
        @aruba.filesystem_permissions(0666, @file_name)
        expect {
          @aruba.check_filesystem_permissions(0755, @file_name, true)
        }.to raise_error
      end

      it "should succeed if mode matches and is expected to be equal" do
        @aruba.filesystem_permissions(0666, @file_name)
        @aruba.check_filesystem_permissions(0666, @file_name, true)
      end

      it "works with ~ in path name" do
        file_name = "~/test_file"

        with_env 'HOME' => File.expand_path(current_dir) do
          File.open(File.expand_path(file_name), 'w') { |f| f << "" }

          @aruba.filesystem_permissions(0666, file_name)
          expect(@aruba.check_filesystem_permissions(0666, file_name, true) ).to eq(true)
        end
      end
    end
    context '#remove_file' do
      before(:each) { File.open(@file_path, 'w') { |f| f << "" } }

      it "should delete file" do
        @aruba.remove_file(@file_name)
        expect(File.exist?(@file_path)).to eq false
      end

      it "works with ~ in path name" do
        file_path = File.join('~', random_string)

        with_env 'HOME' => File.expand_path(current_dir) do
          File.open(File.expand_path(file_path), 'w') { |f| f << "" }
          @aruba.remove_file(file_path)
          expect(File.exist?(file_path)).to eq false
        end
      end
    end

    context '#check_file_presence' do
      before(:each) { File.open(@file_path, 'w') { |f| f << "" } }

      it "should check existence using plain match" do
        file_name = 'nested/dir/hello_world.txt'
        file_path = File.join(@aruba.current_dir, file_name)

        FileUtils.mkdir_p File.dirname( file_path )
        File.open(file_path, 'w') { |f| f << "" }

        @aruba.check_file_presence(file_name)
        @aruba.check_file_presence([file_name])
        @aruba.check_file_presence([file_name], true)
        @aruba.check_file_presence(['asdf'], false)
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

      it "works with ~ in path name" do
        file_path = File.join('~', random_string)

        with_env 'HOME' => File.expand_path(current_dir) do
          FileUtils.mkdir_p File.dirname(File.expand_path(file_path))
          File.open(File.expand_path(file_path), 'w') { |f| f << "" }

          @aruba.check_file_presence( [ file_path ], true )
        end
      end
    end

    context "check file content" do
      before :example do
        @aruba.write_file(@file_name, "foo bar baz")
      end

      context "#check_binary_file_content" do
        it "succeeds if file content matches" do
          @aruba.write_file("fixture", "foo bar baz")
          @aruba.check_binary_file_content(@file_name, "fixture")
          @aruba.check_binary_file_content(@file_name, "fixture", true)
        end

        it "succeeds if file content does not match" do
          @aruba.write_file("wrong_fixture", "bar")
          @aruba.check_binary_file_content(@file_name, "wrong_fixture", false)
        end

        it "raises if file does not exist" do
          expect{@aruba.check_binary_file_content(@file_name, "non_existing", false)}.to raise_error
        end
      end

      context "#check_file_content" do
        context "with regexp" do
          let(:matching_content){/bar/}
          let(:non_matching_content){/nothing/}
          it "succeeds if file content matches" do
            @aruba.check_file_content(@file_name, matching_content)
            @aruba.check_file_content(@file_name, matching_content, true)
          end

          it "succeeds if file content does not match" do
            @aruba.check_file_content(@file_name, non_matching_content, false)
          end

          it "works with ~ in path name" do
            file_path = File.join('~', random_string)

            with_env 'HOME' => File.expand_path(current_dir) do
              @aruba.write_file(file_path, "foo bar baz")
              @aruba.check_file_content(file_path, non_matching_content, false)
            end
          end
        end
        context "with string" do
          let(:matching_content){"foo bar baz"}
          let(:non_matching_content){"bar"}
          it "succeeds if file content matches" do
            @aruba.check_file_content(@file_name, matching_content)
            @aruba.check_file_content(@file_name, matching_content, true)
          end

          it "succeeds if file content does not match" do
            @aruba.check_file_content(@file_name, non_matching_content, false)
          end

          it "works with ~ in path name" do
            file_path = File.join('~', random_string)

            with_env 'HOME' => File.expand_path(current_dir) do
              @aruba.write_file(file_path, "foo bar baz")
              @aruba.check_file_content(file_path, non_matching_content, false)
            end
          end
        end
      end
    end

    context "#with_file_content" do
      before :each do
        @aruba.write_file(@file_name, "foo bar baz")
      end

      it "checks the given file's full content against the expectations in the passed block" do
        @aruba.with_file_content @file_name do |full_content|
          expect(full_content).to eq "foo bar baz"
        end
      end

      it "works with ~ in path name" do
        file_path = File.join('~', random_string)

        with_env 'HOME' => File.expand_path(current_dir) do
          @aruba.write_file(file_path, "foo bar baz")

          @aruba.with_file_content file_path do |full_content|
            expect(full_content).to eq "foo bar baz"
          end
        end
      end

      context "checking the file's content against the expectations in the block" do
        it "is successful when the inner expectations match" do
          expect do
            @aruba.with_file_content @file_name do |full_content|
              expect(full_content).to     match(/foo/)
              expect(full_content).not_to match(/zoo/)
            end
          end . not_to raise_error
        end

        it "raises RSpec::Expectations::ExpectationNotMetError when the inner expectations don't match"  do
          expect do
            @aruba.with_file_content @file_name do |full_content|
              expect(full_content).to     match(/zoo/)
              expect(full_content).not_to match(/foo/)
            end
          end . to raise_error RSpec::Expectations::ExpectationNotMetError
        end
      end
    end #with_file_content
  end

  describe 'process environment' do
    context '#with_env' do
      it 'modifies env for block' do
        variable = 'THIS_IS_A_ENV_VAR'
        ENV[variable] = '1'

        with_env variable => '0' do
          expect(ENV[variable]).to eq '0'
        end

        expect(ENV[variable]).to eq '1'
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

  describe "#set_env" do
    after(:each) do
      @aruba.stop_processes!
      @aruba.restore_env
    end
    it "set environment variable" do
      @aruba.set_env 'LONG_LONG_ENV_VARIABLE', 'true'
      @aruba.run "env"
      expect(@aruba.all_output).to include("LONG_LONG_ENV_VARIABLE=true")
    end
    it "overwrites environment variable" do
      @aruba.set_env 'LONG_LONG_ENV_VARIABLE', 'true'
      @aruba.set_env 'LONG_LONG_ENV_VARIABLE', 'false'
      @aruba.run "env"
      expect(@aruba.all_output).to include("LONG_LONG_ENV_VARIABLE=false")
    end
  end

  describe "#restore_env" do
    after(:each){@aruba.stop_processes!}
    it "restores environment variable" do
      @aruba.set_env 'LONG_LONG_ENV_VARIABLE', 'true'
      @aruba.restore_env
      @aruba.run "env"
      expect(@aruba.all_output).not_to include("LONG_LONG_ENV_VARIABLE")
    end
    it "restores environment variable that has been set multiple times" do
      @aruba.set_env 'LONG_LONG_ENV_VARIABLE', 'true'
      @aruba.set_env 'LONG_LONG_ENV_VARIABLE', 'false'
      @aruba.restore_env
      @aruba.run "env"
      expect(@aruba.all_output).not_to include("LONG_LONG_ENV_VARIABLE")
    end
  end
end # Aruba::Api
