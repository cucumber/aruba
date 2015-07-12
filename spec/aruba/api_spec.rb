require 'spec_helper'
require 'securerandom'
require 'aruba/api'
require 'fileutils'

describe Aruba::Api  do
  include_context 'uses aruba API'

  describe 'current_directory' do
    it "should return the current dir as 'tmp/aruba'" do
      expect(@aruba.aruba.current_directory.to_s).to match(/^tmp\/aruba$/)
    end

    it "can be cleared" do
      write_file('test', 'test test test')

      cd('.') do
        expect(File.exist?('test')).to be true
      end

      setup_aruba

      cd('.') do
        expect(File.exist?('test')).to be false
      end
    end
  end

  describe '#all_paths' do
    let(:name) { @file_name }
    let(:path) { @file_path }

    context 'when file exist' do
      before :each do
        Aruba::Platform.write_file(path, '')
      end

      it { expect(all_paths).to include expand_path(name) }
    end

    context 'when directory exist' do
      let(:name) { 'test_dir' }
      let(:path) { File.join(@aruba.aruba.current_directory, name) }

      before :each do
        Aruba::Platform.mkdir(path)
      end

      it { expect(all_paths).to include expand_path(name) }
    end

    context 'when nothing exist' do
      it { expect(all_paths).to eq [] }
    end
  end

  describe '#all_files' do
    let(:name) { @file_name }
    let(:path) { @file_path }

    context 'when file exist' do
      before :each do
        Aruba::Platform.write_file(path, '')
      end

      it { expect(all_files).to include expand_path(name) }
    end

    context 'when directory exist' do
      let(:name) { 'test_dir' }
      let(:path) { File.join(@aruba.aruba.current_directory, name) }

      before :each do
        Aruba::Platform.mkdir(path)
      end

      it { expect(all_files).to eq [] }
    end

    context 'when nothing exist' do
      it { expect(all_files).to eq [] }
    end
  end

  describe '#all_directories' do
    let(:name) { @file_name }
    let(:path) { @file_path }

    context 'when file exist' do
      before :each do
        Aruba::Platform.write_file(path, '')
      end

      it { expect(all_directories).to eq [] }
    end

    context 'when directory exist' do
      let(:name) { 'test_dir' }
      let(:path) { File.join(@aruba.aruba.current_directory, name) }

      before :each do
        Aruba::Platform.mkdir(path)
      end

      it { expect(all_directories).to include expand_path(name) }
    end

    context 'when nothing exist' do
      it { expect(all_directories).to eq [] }
    end
  end

  describe 'directories' do
    before(:each) do
      @directory_name = 'test_dir'
      @directory_path = File.join(@aruba.aruba.current_directory, @directory_name)
    end

    context '#create_directory' do
      it 'creates a directory' do
        @aruba.create_directory @directory_name
        expect(File.exist?(File.expand_path(@directory_path))).to be_truthy
      end
    end
  end

  describe '#read' do
    let(:name) { 'test.txt'}
    let(:path) { File.join(@aruba.aruba.current_directory, name) }
    let(:content) { 'asdf' }

    before :each do
      @aruba.set_environment_variable 'HOME',  File.expand_path(@aruba.aruba.current_directory)
    end

    context 'when does not exist' do
      it { expect { @aruba.read(name) }.to raise_error ArgumentError }
    end

    context 'when exists' do
      context 'when file' do
        before :each do
          File.open(File.expand_path(path), 'w') { |f| f << content }
        end

        context 'when normal file' do
          it { expect(@aruba.read(name)).to eq [content] }
        end

        context 'when binary file' do
          let(:content) { "\u0000" }
          it { expect(@aruba.read(name)).to eq [content] }
        end

        context 'when is empty file' do
          let(:content) { '' }
          it { expect(@aruba.read(name)).to eq [] }
        end

        context 'when path contains ~' do
          let(:string) { random_string }
          let(:name) { File.join('~', string) }
          let(:path) { File.join(@aruba.aruba.current_directory, string) }

          it { expect(@aruba.read(name)).to eq [content] }
        end
      end

      context 'when directory' do
        let(:name) { 'test.d' }

        before :each do
          Array(path).each { |p| Aruba::Platform.mkdir p }
        end

        it { expect { @aruba.read(name) }.to raise_error ArgumentError }
      end
    end
  end

  describe '#list' do
    let(:name) { 'test.d' }
    let(:content) { %w(subdir.1.d subdir.2.d) }
    let(:path) { File.join(@aruba.aruba.current_directory, name) }

    before :each do
      @aruba.set_environment_variable 'HOME',  File.expand_path(@aruba.aruba.current_directory)
    end

    context 'when does not exist' do
      it { expect { @aruba.list(name) }.to raise_error ArgumentError }
    end

    context 'when exists' do
      context 'when file' do
        let(:name) { 'test.txt' }

        before :each do
          File.open(File.expand_path(path), 'w') { |f| f << content }
        end

        context 'when normal file' do
          it { expect{ @aruba.list(name) }.to raise_error ArgumentError }
        end
      end

      context 'when directory' do
        before :each do
          Array(path).each { |p| Aruba::Platform.mkdir p }
        end

        before :each do
          Array(content).each { |p| Aruba::Platform.mkdir File.join(path, p) }
        end

        context 'when has subdirectories' do
          context 'when is simple path' do
            let(:existing_files) { @aruba.list(name) }
            let(:expected_files) { content.map { |c| File.join(name, c) }.sort  }

            it { expect(expected_files - existing_files).to be_empty}
          end

          context 'when path contains ~' do
            let(:string) { random_string }
            let(:name) { File.join('~', string) }
            let(:path) { File.join(@aruba.aruba.current_directory, string) }

            let(:existing_files) { @aruba.list(name) }
            let(:expected_files) { content.map { |c| File.join(string, c) } }

            it { expect(expected_files - existing_files).to be_empty}
          end
        end

        context 'when has no subdirectories' do
          let(:content) { [] }
          it { expect(@aruba.list(name)).to eq [] }
        end
      end
    end
  end

  describe '#remove' do
    let(:name) { 'test.txt'}
    let(:path) { File.join(@aruba.aruba.current_directory, name) }
    let(:options) { {} }

    before :each do
      @aruba.set_environment_variable 'HOME',  File.expand_path(@aruba.aruba.current_directory)
    end

    context 'when file' do
      context 'when exists' do
        before :each do
          Array(path).each { |p| File.open(File.expand_path(p), 'w') { |f| f << "" } }
        end

        before :each do
          @aruba.remove(name, options)
        end

        context 'when is a single file' do
          it_behaves_like 'a non-existing file'
        end

        context 'when are multiple files' do
          let(:file_name) { %w(file1 file2 file3) }
          let(:file_path) { %w(file1 file2 file3).map { |p| File.join(@aruba.aruba.current_directory, p) } }

          it_behaves_like 'a non-existing file'
        end

        context 'when path contains ~' do
          let(:string) { random_string }
          let(:file_name) { File.join('~', string) }
          let(:file_path) { File.join(@aruba.aruba.current_directory, string) }

          it_behaves_like 'a non-existing file'
        end
      end

      context 'when does not exist' do
        before :each do
          @aruba.remove(name, options)
        end

        context 'when is forced to delete file' do
          let(:options) { { :force => true } }

          it_behaves_like 'a non-existing file'
        end
      end
    end

    context 'when is directory' do
      let(:name) { 'test.d' }

      context 'when exists' do
        before :each do
          Array(path).each { |p| Aruba::Platform.mkdir p }
        end

        before :each do
          @aruba.remove(name, options)
        end

        context 'when is a single directory' do
          it_behaves_like 'a non-existing directory'
        end

        context 'when are multiple directorys' do
          let(:directory_name) { %w(directory1 directory2 directory3) }
          let(:directory_path) { %w(directory1 directory2 directory3).map { |p| File.join(@aruba.aruba.current_directory, p) } }

          it_behaves_like 'a non-existing directory'
        end

        context 'when path contains ~' do
          let(:string) { random_string }
          let(:directory_name) { File.join('~', string) }
          let(:directory_path) { File.join(@aruba.aruba.current_directory, string) }

          it_behaves_like 'a non-existing directory'
        end
      end

      context 'when does not exist' do
        before :each do
          @aruba.remove(name, options)
        end

        context 'when is forced to delete directory' do
          let(:options) { { :force => true } }

          it_behaves_like 'a non-existing directory'
        end
      end
    end
  end

  describe 'files' do
    describe '#touch' do
      let(:name) { @file_name }
      let(:path) { @file_path }
      let(:options) { {} }

      before :each do
        @aruba.set_environment_variable 'HOME',  File.expand_path(@aruba.aruba.current_directory)
      end

      context 'when file' do
        before :each do
          @aruba.touch(name, options)
        end

        context 'when does not exist' do
          context 'and should be created in existing directory' do
            it { expect(File.size(path)).to eq 0 }
            it_behaves_like 'an existing file'
          end

          context 'and should be created in non-existing directory' do
            let(:name) { 'directory/test' }
            let(:path) { File.join(@aruba.aruba.current_directory, 'directory/test') }

            it_behaves_like 'an existing file'
          end

          context 'and path includes ~' do
            let(:string) { random_string }
            let(:name) { File.join('~', string) }
            let(:path) { File.join(@aruba.aruba.current_directory, string) }

            it_behaves_like 'an existing file'
          end

          context 'and the mtime should be set statically' do
            let(:time) { Time.parse('2014-01-01 10:00:00') }
            let(:options) { { :mtime => Time.parse('2014-01-01 10:00:00') } }

            it_behaves_like 'an existing file'
            it { expect(File.mtime(path)).to eq time }
          end

          context 'and multiple file names are given' do
            let(:name) { %w(file1 file2 file3) }
            let(:path) { %w(file1 file2 file3).map { |p| File.join(@aruba.aruba.current_directory, p) } }
            it_behaves_like 'an existing file'
          end
        end
      end

      context 'when directory' do
        let(:name) { %w(directory1) }
        let(:path) { Array(name).map { |p| File.join(@aruba.aruba.current_directory, p) } }

        context 'when exist' do
          before(:each) { Array(path).each { |p| Aruba::Platform.mkdir p } }

          before :each do
            @aruba.touch(name, options)
          end

          context 'and the mtime should be set statically' do
            let(:time) { Time.parse('2014-01-01 10:00:00') }
            let(:options) { { :mtime => Time.parse('2014-01-01 10:00:00') } }

            it_behaves_like 'an existing directory'
            it { Array(path).each { |p| expect(File.mtime(p)).to eq time } }
          end
        end
      end
    end

    describe '#absolute?' do
      let(:name) { @file_name }
      let(:path) { File.expand_path(File.join(@aruba.aruba.current_directory, name)) }

      context 'when is absolute path' do
        it { expect(@aruba).to be_absolute(path) }
      end

      context 'when is relative path' do
        it { expect(@aruba).not_to be_absolute(name) }
      end
    end

    describe '#relative?' do
      let(:name) { @file_name }
      let(:path) { File.expand_path(File.join(@aruba.aruba.current_directory, name)) }

      context 'when is absolute path' do
        it { expect(@aruba).not_to be_relative(path) }
      end

      context 'when is relative path' do
        it { expect(@aruba).to be_relative(name) }
      end
    end

    describe '#exist?' do
      context 'when is file' do
        let(:name) { @file_name }
        let(:path) { @file_path }

        context 'when exists' do
          before :each do
            Aruba::Platform.write_file(path, '')
          end

          it { expect(@aruba).to be_exist(name) }
        end

        context 'when does not exist' do
          it { expect(@aruba).not_to be_exist(name) }
        end
      end

      context 'when is directory' do
        let(:name) { 'test.d' }
        let(:path) { File.join(@aruba.aruba.current_directory, name) }

        context 'when exists' do
          before :each do
            Aruba::Platform.mkdir(path)
          end

          it { expect(@aruba).to be_exist(name) }
        end

        context 'when does not exist' do
          it { expect(@aruba).not_to be_exist(name) }
        end
      end
    end

    describe '#file?' do
      context 'when is file' do
        let(:name) { @file_name }
        let(:path) { @file_path }

        context 'when exists' do
          before :each do
            Aruba::Platform.write_file(path, '')
          end

          it { expect(@aruba).to be_file(name) }
        end

        context 'when does not exist' do
          it { expect(@aruba).not_to be_file(name) }
        end
      end

      context 'when is directory' do
        let(:name) { 'test.d' }
        let(:path) { File.join(@aruba.aruba.current_directory, name) }

        context 'when exists' do
          before :each do
            Aruba::Platform.mkdir(path)
          end

          it { expect(@aruba).not_to be_file(name) }
        end

        context 'when does not exist' do
          it { expect(@aruba).not_to be_file(name) }
        end
      end
    end

    describe '#directory?' do
      context 'when is file' do
        let(:name) { @file_name }
        let(:path) { @file_path }

        context 'when exists' do
          before :each do
            Aruba::Platform.write_file(path, '')
          end

          it { expect(@aruba).not_to be_directory(name) }
        end

        context 'when does not exist' do
          it { expect(@aruba).not_to be_directory(name) }
        end
      end

      context 'when is directory' do
        let(:name) { 'test.d' }
        let(:path) { File.join(@aruba.aruba.current_directory, name) }

        context 'when exists' do
          before :each do
            Aruba::Platform.mkdir(path)
          end

          it { expect(@aruba).to be_directory(name) }
        end

        context 'when does not exist' do
          it { expect(@aruba).not_to be_directory(name) }
        end
      end
    end

    describe '#copy' do
      let(:source) { 'file.txt' }
      let(:destination) { 'file1.txt' }

      context 'when source is existing' do
        context 'when destination is non-existing' do
          context 'when source is file' do
            before(:each) { create_test_files(source) }

            before :each do
              @aruba.copy source, destination
            end

            context 'when source is plain file' do
              it { expect(destination).to be_an_existing_file }
            end

            context 'when source is contains "~" in path' do
              let(:source) { '~/file.txt' }
              it { expect(destination).to be_an_existing_file }
            end

            context 'when source is fixture' do
              let(:source) { '%/copy/file.txt' }
              let(:destination) { 'file.txt' }
              it { expect(destination).to be_an_existing_file }
            end

            context 'when source is list of files' do
              let(:source) { %w(file1.txt file2.txt file3.txt) }
              let(:destination) { 'file.d' }
              let(:destination_files) { source.map { |s| File.join(destination, s) } }

              it { expect(destination_files).to all be_an_existing_file }
            end
          end

          context 'when source is directory' do
            let(:source) { 'src.d' }
            let(:destination) { 'dst.d' }

            before :each do
              Aruba::Platform.mkdir(File.join(@aruba.aruba.current_directory, source))
            end

            before :each do
              @aruba.copy source, destination
            end

            context 'when source is single directory' do
              it { expect(destination).to be_an_existing_directory }
            end

            context 'when source is nested directory' do
              let(:source) { 'src.d/subdir.d' }
              let(:destination) { 'dst.d/' }

              it { expect(destination).to be_an_existing_directory }
            end
          end
        end

        context 'when destination is existing' do
          context 'when source is list of files' do
            before(:each) { create_test_files(source) }

            context 'when destination is directory' do
              let(:source) { %w(file1.txt file2.txt file3.txt) }
              let(:destination) { 'file.d' }
              let(:destination_files) { source.map { |s| File.join(destination, s) } }

              before :each do
                Aruba::Platform.mkdir(File.join(@aruba.aruba.current_directory, destination))
              end

              before :each do
                @aruba.copy source, destination
              end

              it { source.each { |s| expect(destination_files).to all be_an_existing_file } }
            end

            context 'when destination is not a directory' do
              let(:source) { %w(file1.txt file2.txt file3.txt) }
              let(:destination) { 'file.txt' }

              before(:each) { create_test_files(destination) }

              it { expect { @aruba.copy source, destination }.to raise_error ArgumentError, "Multiples sources can only be copied to a directory" }
            end

            context 'when a source is the same like destination' do
              let(:source) { 'file1.txt' }
              let(:destination) { 'file1.txt' }

              before(:each) { create_test_files(source) }

              # rubocop:disable Metrics/LineLength
              it { expect { @aruba.copy source, destination }.to raise_error ArgumentError, %(same file: #{File.expand_path(File.join(@aruba.aruba.current_directory, source))} and #{File.expand_path(File.join(@aruba.aruba.current_directory, destination))}) }
              # rubocop:enable Metrics/LineLength
            end

            context 'when a fixture is destination' do
              let(:source) { '%/copy/file.txt' }
              let(:destination) { '%/copy/file.txt' }

              it { expect { @aruba.copy source, destination }.to raise_error ArgumentError, "Using a fixture as destination (#{destination}) is not supported" }
            end
          end
        end

        context 'when source is non-existing' do
          it { expect { @aruba.copy source, destination }.to raise_error ArgumentError}
        end
      end
    end

    context '#absolute_path' do
      context 'when file_name is array of path names' do
        it { silence(:stderr) { expect(@aruba.absolute_path(['path', @file_name])).to eq File.expand_path(File.join(aruba.current_directory, 'path', @file_name)) } }
      end
    end

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
      let(:permissions) { '0655' }

      before :each do
        @aruba.set_environment_variable 'HOME',  File.expand_path(@aruba.aruba.current_directory)
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
          let(:permissions) { 0655 }
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
        @aruba.set_environment_variable 'HOME',  File.expand_path(@aruba.aruba.current_directory)
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
            let(:file_path) { File.join(@aruba.aruba.current_directory, string) }

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

    context '#check_file_presence' do
      before(:each) { File.open(@file_path, 'w') { |f| f << "" } }

      it "should check existence using plain match" do
        file_name = 'nested/dir/hello_world.txt'
        file_path = File.join(@aruba.aruba.current_directory, file_name)

        Aruba::Platform.mkdir(File.dirname(file_path))
        File.open(file_path, 'w') { |f| f << "" }

        @aruba.check_file_presence(file_name)
        @aruba.check_file_presence([file_name])
        @aruba.check_file_presence([file_name], true)
        @aruba.check_file_presence(['asdf'], false)
      end

      it "should check existence using regex" do
        file_name = 'nested/dir/hello_world.txt'
        file_path = File.join(@aruba.aruba.current_directory, file_name)

        Aruba::Platform.mkdir(File.dirname(file_path))
        File.open(file_path, 'w') { |f| f << "" }

        @aruba.check_file_presence([ /test123/ ], false )
        @aruba.check_file_presence([ /hello_world.txt$/ ], true )
        @aruba.check_file_presence([ /dir/ ], true )
        @aruba.check_file_presence([ %r{nested/.+/} ], true )
      end

      it "is no problem to mix both" do
        file_name = 'nested/dir/hello_world.txt'
        file_path = File.join(@aruba.aruba.current_directory, file_name)

        Aruba::Platform.mkdir(File.dirname(file_path))
        File.open(file_path, 'w') { |f| f << "" }

        @aruba.check_file_presence([ file_name, /nested/  ], true )
        @aruba.check_file_presence([ /test123/, 'asdf' ], false )
      end

      it "works with ~ in path name" do
        file_path = File.join('~', random_string)

        @aruba.with_environment 'HOME' => File.expand_path(@aruba.aruba.current_directory) do
          Aruba::Platform.mkdir(File.dirname(File.expand_path(file_path)))
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
    context '#with_environment' do
      it 'modifies env for block' do
        variable = 'THIS_IS_A_ENV_VAR'
        ENV[variable] = '1'

        @aruba.with_environment variable => '0' do
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
        before :each do
          @aruba.send(:announcer).activate(:stdout)
        end

        it "should announce to stdout exactly once" do
          result = capture(:stdout) do
            @aruba.run_simple('echo "hello world"', false)
          end

          expect(result).to include('hello world')
          expect(@aruba.all_output).to include('hello world')
        end
      end

      context 'disabled' do
        it "should not announce to stdout" do
          result = capture(:stdout) do
            @aruba.run_simple('echo "hello world"', false)
          end

          expect(result).not_to include('hello world')
          expect(@aruba.all_output).to include('hello world')
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

  describe '#run' do
    before(:each){@aruba.run "cat"}
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
