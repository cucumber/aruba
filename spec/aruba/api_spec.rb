require 'spec_helper'
require 'securerandom'

describe Aruba::Api  do
  include_context 'uses aruba API'

  describe 'current_directory' do
    it "should return the current dir as 'tmp/aruba'" do
      expect(@aruba.current_directory).to match(/^tmp\/aruba$/)
    end

    it "can be cleared" do
      write_file('test', 'test test test')

      in_current_directory do
        expect(File.exist?('test')).to be_truthy
      end

      clean_current_directory

      in_current_directory do
        expect(File.exist?('test')).to be_falsey
      end

    end
  end

  describe 'directories' do
    before(:each) do
      @directory_name = 'test_dir'
      @directory_path = File.join(@aruba.current_directory, @directory_name)
    end

    context '#create_directory' do
      it 'creates a directory' do
        @aruba.create_directory @directory_name
        expect(File.exist?(File.expand_path(@directory_path))).to be_truthy
      end
    end

    describe '#remove_directory' do
      let(:directory_name) { @directory_name }
      let(:directory_path) { @directory_path }
      let(:options) { {} }

      before :each do
        set_env 'HOME',  File.expand_path(@aruba.current_directory)
      end

      context 'when directory exists' do
        before :each do
          Array(directory_path).each { |p| Dir.mkdir p }
        end

        before :each do
          @aruba.remove_directory(directory_name, options)
        end

        context 'when is a single directory' do
          it_behaves_like 'a non-existing directory'
        end

        context 'when are multiple directorys' do
          let(:directory_name) { %w(directory1 directory2 directory3) }
          let(:directory_path) { %w(directory1 directory2 directory3).map { |p| File.join(@aruba.current_directory, p) } }

          it_behaves_like 'a non-existing directory'
        end

        context 'when path contains ~' do
          let(:string) { random_string }
          let(:directory_name) { File.join('~', string) }
          let(:directory_path) { File.join(@aruba.current_directory, string) }

          it_behaves_like 'a non-existing directory'
        end
      end

      context 'when directory does not exist' do
        before :each do
          @aruba.remove_directory(directory_name, options)
        end

        context 'when is forced to delete directory' do
          let(:options) { { force: true } }

          it_behaves_like 'a non-existing directory'
        end
      end
    end
  end

  describe 'files' do
    describe '#touch_file' do
      let(:file_name) { @file_name }
      let(:file_path) { @file_path }
      let(:options) { {} }

      before :each do
        set_env 'HOME',  File.expand_path(@aruba.current_directory)
      end

      before :each do
        @aruba.touch_file(file_name, options)
      end

      context 'when file does not exist' do
        context 'and should be created in existing directory' do
          it { expect(File.size(file_path)).to eq 0 }
          it_behaves_like 'an existing file'
        end

        context 'and should be created in non-existing directory' do
          let(:file_name) { 'directory/test' }
          let(:file_path) { File.join(@aruba.current_directory, 'directory/test') }

          it_behaves_like 'an existing file'
        end

        context 'and path includes ~' do
          let(:string) { random_string }
          let(:file_name) { File.join('~', string) }
          let(:file_path) { File.join(@aruba.current_directory, string) }

          it_behaves_like 'an existing file'
        end

        context 'and the mtime should be set statically' do
          let(:time) { Time.parse('2014-01-01 10:00:00') }
          let(:options) { { mtime: Time.parse('2014-01-01 10:00:00') } }

          it_behaves_like 'an existing file'
          it { expect(File.mtime(file_path)).to eq time }
        end

        context 'and multiple file names are given' do
          let(:file_name) { %w(file1 file2 file3) }
          let(:file_path) { %w(file1 file2 file3).map { |p| File.join(@aruba.current_directory, p) } }
          it_behaves_like 'an existing file'
        end
      end
    end

    context '#expand_path' do
      it 'expands and returns path' do
        expect(@aruba.expand_path(@file_name)).to eq File.expand_path(@file_path)
      end

      it 'removes "."' do
        expect(@aruba.expand_path('.')).to eq File.expand_path(current_directory)
      end

      it 'removes ".."' do
        expect(@aruba.expand_path('..')).to eq File.expand_path(File.join(current_directory, '..'))
      end

      it 'expands from another directory' do
        expect(@aruba.expand_path(@file_name, 'path')).to eq File.expand_path(File.join(current_directory, 'path', @file_name))
      end

      it 'resolves fixtures path' do
        klass = Class.new do
          include Aruba::Api

          def root_directory
            File.expand_path(current_directory)
          end
        end

        aruba = klass.new

        aruba.touch_file 'spec/fixtures/file1'

        expect(aruba.expand_path('%/file1')).to eq File.expand_path(File.join(current_directory, 'spec', 'fixtures', 'file1'))
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

        with_env 'HOME' => File.expand_path(current_directory) do
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

        with_env 'HOME' => File.expand_path(current_directory) do
          @aruba.write_fixed_size_file(file_path, @file_size)
          @aruba.check_file_size([[file_path, @file_size]])
        end
      end

      it "should check an existing file size and fail" do
        @aruba.write_fixed_size_file(@file_name, @file_size)
        expect { @aruba.check_file_size([[@file_name, @file_size + 1]]) }.to raise_error
      end
    end

    describe '#filesystem_permissions' do
      def actuctual_permissions
        sprintf( "%o" , File::Stat.new(file_path).mode )[-4,4]
      end

      let(:file_name) { @file_name }
      let(:file_path) { @file_path }
      let(:permissions) { '0655' }

      before(:each) do
        File.open(file_path, 'w') { |f| f << "" }
      end

      before(:each) do
        @aruba.filesystem_permissions(permissions, file_name)
      end

      context 'when file exists' do
        context 'and permissions are given as string' do
          it { expect(actuctual_permissions).to eq('0655') }
        end

        context 'and permissions are given as octal number' do
          let(:permissions) { 0655 }
          it { expect(actuctual_permissions).to eq('0655') }
        end

        context 'and path has ~ in it' do
          let(:string) { random_string }
          let(:file_name) { File.join('~', string) }
          let(:file_path) { File.join(@aruba.current_directory, string) }

          it { expect(actuctual_permissions).to eq('0655') }
        end
      end
    end

    describe '#check_filesystem_permissions' do
      let(:file_name) { @file_name }
      let(:file_path) { @file_path }

      let(:permissions) { '0655' }

      before :each do
        set_env 'HOME',  File.expand_path(@aruba.current_directory)
      end

      before(:each) do
        File.open(file_path, 'w') { |f| f << "" }
      end

      before(:each) do
        @aruba.filesystem_permissions(permissions, file_name)
      end

      context 'when file exists' do
        context 'and should have permissions' do
          context 'and permissions are given as string' do
            it { @aruba.check_filesystem_permissions(permissions, file_name, true) }
          end

          context 'and permissions are given as octal number' do
            let(:permissions) { 0666 }

            it { @aruba.check_filesystem_permissions(permissions, file_name, true) }
          end

          context 'and path includes ~' do
            let(:string) { random_string }
            let(:file_name) { File.join('~', string) }
            let(:file_path) { File.join(@aruba.current_directory, string) }

            it { @aruba.check_filesystem_permissions(permissions, file_name, true) }
          end

          context 'but fails because the permissions are different' do
            let(:expected_permissions) { 0666 }

            it { expect { @aruba.check_filesystem_permissions(expected_permissions, file_name, true) }.to raise_error }
          end
        end

        context 'and should not have permissions' do
          context 'and succeeds when the difference is expected and permissions are different' do
            let(:different_permissions) { 0666 }

            it { @aruba.check_filesystem_permissions(different_permissions, file_name, false) }
          end

          context 'and fails because the permissions are the same although they should be different' do
            let(:different_permissions) { 0655 }

            it { expect { @aruba.check_filesystem_permissions(different_permissions, file_name, false) }.to raise_error }
          end
        end
      end
    end

    describe '#remove_file' do
      let(:file_name) { @file_name }
      let(:file_path) { @file_path }
      let(:options) { {} }

      before :each do
        set_env 'HOME',  File.expand_path(@aruba.current_directory)
      end

      context 'when file exists' do
        before :each do
          Array(file_path).each { |p| File.open(File.expand_path(p), 'w') { |f| f << "" } }
        end

        before :each do
          @aruba.remove_file(file_name, options)
        end

        context 'when is a single file' do
          it_behaves_like 'a non-existing file'
        end

        context 'when are multiple files' do
          let(:file_name) { %w(file1 file2 file3) }
          let(:file_path) { %w(file1 file2 file3).map { |p| File.join(@aruba.current_directory, p) } }

          it_behaves_like 'a non-existing file'
        end

        context 'when path contains ~' do
          let(:string) { random_string }
          let(:file_name) { File.join('~', string) }
          let(:file_path) { File.join(@aruba.current_directory, string) }

          it_behaves_like 'a non-existing file'
        end
      end

      context 'when file does not exist' do
        before :each do
          @aruba.remove_file(file_name, options)
        end

        context 'when is forced to delete file' do
          let(:options) { { force: true } }

          it_behaves_like 'a non-existing file'
        end
      end
    end

    context '#check_file_presence' do
      before(:each) { File.open(@file_path, 'w') { |f| f << "" } }

      it "should check existence using plain match" do
        file_name = 'nested/dir/hello_world.txt'
        file_path = File.join(@aruba.current_directory, file_name)

        FileUtils.mkdir_p File.dirname( file_path )
        File.open(file_path, 'w') { |f| f << "" }

        @aruba.check_file_presence(file_name)
        @aruba.check_file_presence([file_name])
        @aruba.check_file_presence([file_name], true)
        @aruba.check_file_presence(['asdf'], false)
      end

      it "should check existence using regex" do
        file_name = 'nested/dir/hello_world.txt'
        file_path = File.join(@aruba.current_directory, file_name)

        FileUtils.mkdir_p File.dirname( file_path )
        File.open(file_path, 'w') { |f| f << "" }

        @aruba.check_file_presence([ /test123/ ], false )
        @aruba.check_file_presence([ /hello_world.txt$/ ], true )
        @aruba.check_file_presence([ /dir/ ], true )
        @aruba.check_file_presence([ %r{nested/.+/} ], true )
      end

      it "is no problem to mix both" do
        file_name = 'nested/dir/hello_world.txt'
        file_path = File.join(@aruba.current_directory, file_name)

        FileUtils.mkdir_p File.dirname( file_path )
        File.open(file_path, 'w') { |f| f << "" }

        @aruba.check_file_presence([ file_name, /nested/  ], true )
        @aruba.check_file_presence([ /test123/, 'asdf' ], false )
      end

      it "works with ~ in path name" do
        file_path = File.join('~', random_string)

        with_env 'HOME' => File.expand_path(current_directory) do
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

      describe "#check_binary_file_content" do
        let(:file_name) { @file_name }
        let(:file_path) { @file_path }

        let(:reference_file) { 'fixture' }
        let(:reference_file_content) { 'foo bar baz' }

        before :each do
          @aruba.write_file(reference_file, reference_file_content)
        end

        context 'when files are the same' do
          context 'and this is expected' do
            it { @aruba.check_binary_file_content(file_name, reference_file) }
            it { @aruba.check_binary_file_content(file_name, reference_file, true) }
          end

          context 'and this is not expected' do
            it { expect { @aruba.check_binary_file_content(file_name, reference_file, false) }.to raise_error }
          end
        end

        context 'when files are not the same' do
          let(:reference_file_content) { 'bar' }

          context 'and this is expected' do
            it { @aruba.check_binary_file_content(file_name, reference_file, false) }
          end

          context 'and this is not expected' do
            it { expect { @aruba.check_binary_file_content(file_name, reference_file, true) }.to raise_error }
          end
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

            with_env 'HOME' => File.expand_path(current_directory) do
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

            with_env 'HOME' => File.expand_path(current_directory) do
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

        with_env 'HOME' => File.expand_path(current_directory) do
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

  describe 'fixtures' do
    let(:aruba) do
      klass = Class.new do
        include Aruba::Api

        def root_directory
          expand_path('.')
        end
      end

      klass.new
    end

    describe '#fixtures_directory' do
      context 'when no fixtures directories exist' do
        it "should raise exception" do
          expect { aruba.fixtures_directory }.to raise_error
        end
      end

      context 'when "/features/fixtures"-directory exist' do
        before(:each) { aruba.create_directory('features/fixtures') }

        it { expect(aruba.fixtures_directory).to eq expand_path('features/fixtures') }
      end

      context 'when "/spec/fixtures"-directory exist' do
        before(:each) { aruba.create_directory('spec/fixtures') }

        it { expect(aruba.fixtures_directory).to eq expand_path('spec/fixtures') }
      end

      context 'when "/test/fixtures"-directory exist' do
        before(:each) { aruba.create_directory('test/fixtures') }

        it { expect(aruba.fixtures_directory).to eq expand_path('test/fixtures') }
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
