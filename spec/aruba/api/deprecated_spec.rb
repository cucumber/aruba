require 'spec_helper'

RSpec.describe 'Deprecated API' do
  include_context 'uses aruba API'

  around do |example|
    Aruba.platform.with_environment do
      example.run
    end
  end

  before do
    allow(Aruba.platform).to receive(:deprecated)
  end

  describe '#absolute_path' do
    context 'when file_name is array of path names' do
      it { expect(@aruba.absolute_path(['path', @file_name])).to eq File.expand_path(File.join(aruba.current_directory, 'path', @file_name)) }
    end
  end

  describe "#assert_not_matching_output" do
    before(:each){ @aruba.run_simple("echo foo", false) }
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

  describe '#filesystem_permissions' do
    def actual_permissions
      format( "%o" , File::Stat.new(file_path).mode )[-4,4]
    end

    let(:file_name) { @file_name }
    let(:file_path) { @file_path }
    let(:permissions) { '0655' }

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
        it { expect(actual_permissions).to eq('0655') }
      end

      context 'and permissions are given as octal number' do
        let(:permissions) { 0o655 }
        it { expect(actual_permissions).to eq('0655') }
      end

      context 'and path has ~ in it' do
        let(:path) { random_string }
        let(:file_name) { File.join('~', path) }
        let(:file_path) { File.join(@aruba.aruba.current_directory, path) }

        it { expect(actual_permissions).to eq('0655') }
      end
    end
  end

  describe '#check_filesystem_permissions' do
    let(:file_name) { @file_name }
    let(:file_path) { @file_path }

    let(:permissions) { '0655' }

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

          it { expect { @aruba.check_filesystem_permissions(expected_permissions, file_name, true) }.to raise_error RSpec::Expectations::ExpectationNotMetError }
        end
      end

      context 'and should not have permissions' do
        context 'and succeeds when the difference is expected and permissions are different' do
          let(:different_permissions) { 0o666 }

          it { @aruba.check_filesystem_permissions(different_permissions, file_name, false) }
        end

        context 'and fails because the permissions are the same although they should be different' do
          let(:different_permissions) { 0o655 }

          it { expect { @aruba.check_filesystem_permissions(different_permissions, file_name, false) }.to raise_error RSpec::Expectations::ExpectationNotMetError }
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
          it { expect { @aruba.check_binary_file_content(file_name, reference_file, false) }.to raise_error RSpec::Expectations::ExpectationNotMetError }
        end
      end

      context 'when files are not the same' do
        let(:reference_file_content) { 'bar' }

        context 'and this is expected' do
          it { @aruba.check_binary_file_content(file_name, reference_file, false) }
        end

        context 'and this is not expected' do
          it { expect { @aruba.check_binary_file_content(file_name, reference_file, true) }.to raise_error RSpec::Expectations::ExpectationNotMetError }
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

  context '#check_file_size' do
    it "should check an existing file size" do
      @aruba.write_fixed_size_file(@file_name, @file_size)
      @aruba.check_file_size([[@file_name, @file_size]])
    end

    it "should check an existing file size and fail" do
      @aruba.write_fixed_size_file(@file_name, @file_size)
      expect { @aruba.check_file_size([[@file_name, @file_size + 1]]) }.to raise_error RSpec::Expectations::ExpectationNotMetError
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
      expect { @aruba.check_file_size([[@file_name, @file_size + 1]]) }.to raise_error RSpec::Expectations::ExpectationNotMetError
    end
  end

  describe "#get_process" do
    before(:each){@aruba.run_simple "true"}
    after(:each) { @aruba.all_commands.each(&:stop) }

    it "returns a process" do
      expect(@aruba.get_process("true")).not_to be(nil)
    end

    it "raises a descriptive exception" do
      expect { @aruba.get_process("false") }.to raise_error Aruba::CommandNotFoundError, "No command named 'false' has been started"
    end
  end

  describe '#set_env' do
    context 'when non-existing variable' do
      before :each do
        ENV.delete('LONG_LONG_ENV_VARIABLE')
      end

      context 'when string' do
        before :each do
          @aruba.set_env 'LONG_LONG_ENV_VARIABLE', '1'
        end

        it { expect(ENV['LONG_LONG_ENV_VARIABLE']).to eq '1' }
      end
    end

    context 'when existing variable set by aruba' do
      before :each do
        @aruba.set_env 'LONG_LONG_ENV_VARIABLE', '1'
        @aruba.set_env 'LONG_LONG_ENV_VARIABLE', '2'
      end

      it { expect(ENV['LONG_LONG_ENV_VARIABLE']).to eq '2' }
    end

    context 'when existing variable by outer context' do
      before :each do
        ENV['LONG_LONG_ENV_VARIABLE'] = '1'
        @aruba.set_env 'LONG_LONG_ENV_VARIABLE', '2'
      end

      it { expect(ENV['LONG_LONG_ENV_VARIABLE']).to eq '2' }
    end
  end

  describe '#restore_env' do
    context 'when non-existing variable' do
      before :each do
        ENV.delete 'LONG_LONG_ENV_VARIABLE'
      end

      context 'when set once' do
        before :each do
          @aruba.set_env 'LONG_LONG_ENV_VARIABLE', '1'
          @aruba.restore_env
        end

        it { expect(ENV).not_to have_key 'LONG_LONG_ENV_VARIABLE' }
      end

      context 'when set multiple times' do
        before :each do
          @aruba.set_env 'LONG_LONG_ENV_VARIABLE', '1'
          @aruba.set_env 'LONG_LONG_ENV_VARIABLE', '2'
          @aruba.set_env 'LONG_LONG_ENV_VARIABLE', '3'
          @aruba.restore_env
        end

        it { expect(ENV).not_to have_key 'LONG_LONG_ENV_VARIABLE' }
      end
    end

    context 'when existing variable from outer context' do
      before :each do
        ENV['LONG_LONG_ENV_VARIABLE'] = '0'
      end

      context 'when set once' do
        before :each do
          @aruba.set_env 'LONG_LONG_ENV_VARIABLE', '1'
          @aruba.restore_env
        end

        it { expect(ENV['LONG_LONG_ENV_VARIABLE']).to eq '0' }
      end

      context 'when set multiple times' do
        before :each do
          @aruba.set_env 'LONG_LONG_ENV_VARIABLE', '1'
          @aruba.set_env 'LONG_LONG_ENV_VARIABLE', '2'
          @aruba.set_env 'LONG_LONG_ENV_VARIABLE', '3'
          @aruba.restore_env
        end

        it { expect(ENV['LONG_LONG_ENV_VARIABLE']).to eq '0' }
      end
    end
  end

  describe "#restore_env" do
    after(:each) { @aruba.all_commands.each(&:stop) }

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
end
