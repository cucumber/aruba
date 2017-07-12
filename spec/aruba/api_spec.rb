require 'spec_helper'
require 'securerandom'
require 'aruba/api'
require 'fileutils'

describe Aruba::Api do
  include_context 'uses aruba API'

  describe 'files' do
    context '#expand_path' do
      context 'when file_name is given' do
        it { expect(@aruba.expand_path(@file_name)).to eq File.expand_path(@file_path) }
      end

      context 'when path contains "."' do
        it { expect(@aruba.expand_path('.')).to eq File.expand_path(aruba.current_directory) }
      end

      context 'when path contains ".."' do
        it { expect(@aruba.expand_path('path/..')).to eq File.expand_path(File.join(aruba.current_directory)) }
      end

      context 'when path is nil' do
        it { expect { @aruba.expand_path(nil) }.to raise_error ArgumentError }
      end

      context 'when path is empty' do
        it { expect { @aruba.expand_path('') }.to raise_error ArgumentError }
      end

      context 'when dir_path is given similar to File.expand_path ' do
        it { expect(@aruba.expand_path(@file_name, 'path')).to eq File.expand_path(File.join(aruba.current_directory, 'path', @file_name)) }
      end

      context 'when file_name contains fixtures "%" string' do
        let(:runtime) { instance_double('Aruba::Runtime') }
        let(:config) { double('Aruba::Config') }
        let(:environment) { instance_double('Aruba::Environment') }

        let(:klass) do
          Class.new do
            include Aruba::Api

            attr_reader :aruba

            def initialize(aruba)
              @aruba = aruba
            end
          end
        end

        before :each do
          allow(config).to receive(:fixtures_path_prefix).and_return('%')
          allow(config).to receive(:root_directory).and_return aruba.config.root_directory
          allow(config).to receive(:working_directory).and_return aruba.config.working_directory
        end

        before :each do
          allow(environment).to receive(:clear)
          allow(environment).to receive(:update).and_return(environment)
          allow(environment).to receive(:to_h).and_return('PATH' => aruba.current_directory.to_s)
        end

        before :each do
          allow(runtime).to receive(:config).and_return config
          allow(runtime).to receive(:environment).and_return environment
          allow(runtime).to receive(:current_directory).and_return aruba.current_directory
          allow(runtime).to receive(:root_directory).and_return aruba.root_directory
          allow(runtime).to receive(:fixtures_directory).and_return File.join(aruba.root_directory, aruba.current_directory, 'spec', 'fixtures')
        end

        before :each do
          @aruba = klass.new(runtime)
          @aruba.touch 'spec/fixtures/file1'
        end

        it { expect(@aruba.expand_path('%/file1')).to eq File.expand_path(File.join(aruba.current_directory, 'spec', 'fixtures', 'file1')) }
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

        @aruba.with_environment 'HOME' => File.expand_path(aruba.current_directory) do
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

        @aruba.with_environment 'HOME' => File.expand_path(aruba.current_directory) do
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
      def actual_permissions
        format( "%o" , File::Stat.new(file_path).mode )[-4,4]
      end

      let(:file_name) { @file_name }
      let(:file_path) { @file_path }
      let(:permissions) { '0644' }

      before :each do
        @aruba.set_environment_variable 'HOME', File.expand_path(@aruba.aruba.current_directory)
      end

      before(:each) do
        File.open(file_path, 'w') { |f| f << "" }
      end

      before(:each) do
        @aruba.filesystem_permissions(permissions, file_name)
      end

      context 'when file exists' do
        context 'and permissions are given as string' do
          it { expect(actual_permissions).to eq('0644') }
        end

        context 'and permissions are given as octal number' do
          let(:permissions) { 0o644 }
          it { expect(actual_permissions).to eq('0644') }
        end

        context 'and path has ~ in it' do
          let(:path) { random_string }
          let(:file_name) { File.join('~', path) }
          let(:file_path) { File.join(@aruba.aruba.current_directory, path) }

          it { expect(actual_permissions).to eq('0644') }
        end
      end
    end

    describe '#check_filesystem_permissions' do
      let(:file_name) { @file_name }
      let(:file_path) { @file_path }

      let(:permissions) { '0644' }

      before :each do
        @aruba.set_environment_variable 'HOME', File.expand_path(@aruba.aruba.current_directory)
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
            let(:permissions) { 0o666 }

            it { @aruba.check_filesystem_permissions(permissions, file_name, true) }
          end

          context 'and path includes ~' do
            let(:string) { random_string }
            let(:file_name) { File.join('~', string) }
            let(:file_path) { File.join(@aruba.aruba.current_directory, string) }

            it { @aruba.check_filesystem_permissions(permissions, file_name, true) }
          end

          context 'but fails because the permissions are different' do
            let(:expected_permissions) { 0o666 }

            it { expect { @aruba.check_filesystem_permissions(expected_permissions, file_name, true) }.to raise_error }
          end
        end

        context 'and should not have permissions' do
          context 'and succeeds when the difference is expected and permissions are different' do
            let(:different_permissions) { 0o666 }

            it { @aruba.check_filesystem_permissions(different_permissions, file_name, false) }
          end

          context 'and fails because the permissions are the same although they should be different' do
            let(:different_permissions) { 0o644 }

            it { expect { @aruba.check_filesystem_permissions(different_permissions, file_name, false) }.to raise_error }
          end
        end
      end
    end

    context '#check_file_presence' do
      before(:each) { File.open(@file_path, 'w') { |f| f << "" } }

      it "should check existence using plain match" do
        file_name = 'nested/dir/hello_world.txt'
        file_path = File.join(@aruba.aruba.current_directory, file_name)

        Aruba.platform.mkdir(File.dirname(file_path))
        File.open(file_path, 'w') { |f| f << "" }

        @aruba.check_file_presence(file_name)
        @aruba.check_file_presence([file_name])
        @aruba.check_file_presence([file_name], true)
        @aruba.check_file_presence(['asdf'], false)
      end

      it "should check existence using regex" do
        file_name = 'nested/dir/hello_world.txt'
        file_path = File.join(@aruba.aruba.current_directory, file_name)

        Aruba.platform.mkdir(File.dirname(file_path))
        File.open(file_path, 'w') { |f| f << "" }

        @aruba.check_file_presence([ /test123/ ], false )
        @aruba.check_file_presence([ /hello_world.txt$/ ], true )
        @aruba.check_file_presence([ /dir/ ], true )
        @aruba.check_file_presence([ %r{nested/.+/} ], true )
      end

      it "is no problem to mix both" do
        file_name = 'nested/dir/hello_world.txt'
        file_path = File.join(@aruba.aruba.current_directory, file_name)

        Aruba.platform.mkdir(File.dirname(file_path))
        File.open(file_path, 'w') { |f| f << "" }

        @aruba.check_file_presence([ file_name, /nested/  ], true )
        @aruba.check_file_presence([ /test123/, 'asdf' ], false )
      end

      it "works with ~ in path name" do
        file_path = File.join('~', random_string)

        @aruba.with_environment 'HOME' => File.expand_path(@aruba.aruba.current_directory) do
          Aruba.platform.mkdir(File.dirname(File.expand_path(file_path)))
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

            @aruba.with_environment 'HOME' => File.expand_path(aruba.current_directory) do
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

            @aruba.with_environment 'HOME' => File.expand_path(aruba.current_directory) do
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

        @aruba.with_environment 'HOME' => File.expand_path(aruba.current_directory) do
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

        it "raises RSpec::Expectations::ExpectationNotMetError when the inner expectations don't match" do
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
    context '#with_environment' do
      it 'modifies env for block' do
        variable = 'THIS_IS_A_ENV_VAR'
        ENV[variable] = '1'

        @aruba.with_environment variable => '0' do
          expect(ENV[variable]).to eq '0'
        end

        expect(ENV[variable]).to eq '1'
      end

      it 'works together with #set_environment_variable' do
        variable = 'THIS_IS_A_ENV_VAR'
        @aruba.set_environment_variable variable, '1'

        @aruba.with_environment do
          expect(ENV[variable]).to eq '1'
          @aruba.set_environment_variable variable, '0'
          @aruba.with_environment do
            expect(ENV[variable]).to eq '0'
          end
          expect(ENV[variable]).to eq '1'
        end
      end

      it 'works with a mix of ENV and #set_environment_variable' do
        variable = 'THIS_IS_A_ENV_VAR'
        @aruba.set_environment_variable variable, '1'
        ENV[variable] = '2'
        expect(ENV[variable]).to eq '2'

        @aruba.with_environment do
          expect(ENV[variable]).to eq '1'
          @aruba.set_environment_variable variable, '0'
          @aruba.with_environment do
            expect(ENV[variable]).to eq '0'
          end
          expect(ENV[variable]).to eq '1'
        end
        expect(ENV[variable]).to eq '2'
      end

      it 'keeps values not set in argument' do
        variable = 'THIS_IS_A_ENV_VAR'
        ENV[variable] = '2'
        expect(ENV[variable]).to eq '2'

        @aruba.with_environment do
          expect(ENV[variable]).to eq '2'
        end
        expect(ENV[variable]).to eq '2'
      end
    end
  end

  describe 'tags' do
    describe '@announce_stdout' do
      after(:each) { @aruba.all_commands.each(&:stop) }

      context 'enabled' do
        before :each do
          @aruba.aruba.announcer = instance_double 'Aruba::Platforms::Announcer'
          expect(@aruba.aruba.announcer).to receive(:announce).with(:stdout) { "hello world\n" }
          allow(@aruba.aruba.announcer).to receive(:announce)
        end

        it "should announce to stdout exactly once" do
          @aruba.run_command_and_stop('echo "hello world"', false)
          expect(@aruba.all_output).to include('hello world')
        end
      end

      context 'disabled' do
        it "should not announce to stdout" do
          result = capture(:stdout) do
            @aruba.run_command_and_stop('echo "hello world"', false)
          end

          expect(result).not_to include('hello world')
          expect(@aruba.all_output).to include('hello world')
        end
      end
    end
  end

  describe "#assert_not_matching_output" do
    before(:each){ @aruba.run_command_and_stop("echo foo", false) }
    after(:each) { @aruba.all_commands.each(&:stop) }

    it "passes when the output doesn't match a regexp" do
      @aruba.assert_not_matching_output "bar", @aruba.all_output
    end
    it "fails when the output does match a regexp" do
      expect do
        @aruba.assert_not_matching_output "foo", @aruba.all_output
      end . to raise_error RSpec::Expectations::ExpectationNotMetError
    end
  end

  describe '#run_command' do
    before(:each){ @aruba.run_command 'cat' }
    after(:each) { @aruba.all_commands.each(&:stop) }

    it "respond to input" do
      @aruba.type "Hello"
      @aruba.type ""
      expect(@aruba.all_output).to eq "Hello\n"
    end

    it "respond to close_input" do
      @aruba.type "Hello"
      @aruba.close_input
      expect(@aruba.all_output).to eq "Hello\n"
    end

    it "pipes data" do
      @aruba.write_file(@file_name, "Hello\nWorld!")
      @aruba.pipe_in_file(@file_name)
      @aruba.close_input
      expect(@aruba.all_output).to eq "Hello\nWorld!"
    end
  end

  describe "#run_command_and_stop" do
    before(:each){@aruba.run_command_and_stop "true"}
    after(:each) { @aruba.all_commands.each(&:stop) }
    describe "get_process" do
      it "returns a process" do
        expect(@aruba.get_process("true")).not_to be(nil)
      end

      it "raises a descriptive exception" do
        expect { @aruba.get_process("false") }.to raise_error CommandNotFoundError, "No command named 'false' has been started"
      end
    end
  end

  describe 'fixtures' do
    let(:api) do
      klass = Class.new do
        include Aruba::Api

        def root_directory
          expand_path('.')
        end
      end

      klass.new
    end
  end

  describe "#set_environment_variable" do
    after(:each) do
      @aruba.all_commands.each(&:stop)
      @aruba.restore_env
    end

    it "set environment variable" do
      @aruba.set_env 'LONG_LONG_ENV_VARIABLE', 'true'
      @aruba.run_command "env"
      expect(@aruba.all_output).to include("LONG_LONG_ENV_VARIABLE=true")
    end

    it "overwrites environment variable" do
      @aruba.set_env 'LONG_LONG_ENV_VARIABLE', 'true'
      @aruba.set_env 'LONG_LONG_ENV_VARIABLE', 'false'
      @aruba.run_command "env"
      expect(@aruba.all_output).to include("LONG_LONG_ENV_VARIABLE=false")
    end
  end

  describe "#restore_env" do
    after(:each) { @aruba.all_commands.each(&:stop) }
    it "restores environment variable" do
      @aruba.set_env 'LONG_LONG_ENV_VARIABLE', 'true'
      @aruba.restore_env
      @aruba.run_command "env"
      expect(@aruba.all_output).not_to include("LONG_LONG_ENV_VARIABLE")
    end
    it "restores environment variable that has been set multiple times" do
      @aruba.set_env 'LONG_LONG_ENV_VARIABLE', 'true'
      @aruba.set_env 'LONG_LONG_ENV_VARIABLE', 'false'
      @aruba.restore_env
      @aruba.run_command "env"
      expect(@aruba.all_output).not_to include("LONG_LONG_ENV_VARIABLE")
    end
  end
end # Aruba::Api
