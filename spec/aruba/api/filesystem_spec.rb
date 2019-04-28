require 'spec_helper'
require 'aruba/api'

RSpec.describe Aruba::Api::Filesystem do
  include_context 'uses aruba API'

  def expand_path(*args)
    @aruba.expand_path(*args)
  end

  describe '#all_paths' do
    let(:name) { @file_name }
    let(:path) { @file_path }

    context 'when file exists' do
      before :each do
        Aruba.platform.write_file(path, '')
      end

      it { expect(all_paths).to include expand_path(name) }
    end

    context 'when directory exists' do
      let(:name) { 'test_dir' }
      let(:path) { File.join(@aruba.aruba.current_directory, name) }

      before :each do
        Aruba.platform.mkdir(path)
      end

      it { expect(all_paths).to include expand_path(name) }
    end

    context 'when nothing exists' do
      it { expect(all_paths).to eq [] }
    end
  end

  describe '#all_files' do
    let(:name) { @file_name }
    let(:path) { @file_path }

    context 'when file exists' do
      before :each do
        Aruba.platform.write_file(path, '')
      end

      it { expect(all_files).to include expand_path(name) }
    end

    context 'when directory exists' do
      let(:name) { 'test_dir' }
      let(:path) { File.join(@aruba.aruba.current_directory, name) }

      before :each do
        Aruba.platform.mkdir(path)
      end

      it { expect(all_files).to eq [] }
    end

    context 'when nothing exists' do
      it { expect(all_files).to eq [] }
    end
  end

  describe '#all_directories' do
    let(:name) { @file_name }
    let(:path) { @file_path }

    context 'when file exists' do
      before :each do
        Aruba.platform.write_file(path, '')
      end

      it { expect(all_directories).to eq [] }
    end

    context 'when directory exists' do
      let(:name) { 'test_dir' }
      let(:path) { File.join(@aruba.aruba.current_directory, name) }

      before :each do
        Aruba.platform.mkdir(path)
      end

      it { expect(all_directories).to include expand_path(name) }
    end

    context 'when nothing exists' do
      it { expect(all_directories).to eq [] }
    end
  end

  describe '#file_size' do
    let(:name) { @file_name }
    let(:path) { @file_path }
    let(:size) { file_size(name) }

    context 'when file exists' do
      before :each do
        File.open(path, 'w') { |f| f.print 'a' }
      end

      it { expect(size).to eq 1 }
    end

    context 'when file does not exist' do
      let(:name) { 'non_existing_file' }
      it { expect { size }.to raise_error ArgumentError }
    end
  end

  describe '#touch' do
    let(:name) { @file_name }
    let(:path) { @file_path }
    let(:options) { {} }

    before :each do
      @aruba.set_environment_variable 'HOME', File.expand_path(@aruba.aruba.current_directory)
    end

    context 'when touching a file that does not exist' do
      before :each do
        @aruba.touch(name, options)
      end

      context 'and should be created in an existing directory' do
        it { expect(File.size(path)).to eq 0 }
        it_behaves_like 'an existing file'
      end

      context 'and should be created in a non-existing directory' do
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

    context 'when touching an existing directory' do
      let(:name) { %w(directory1) }
      let(:path) { Array(name).map { |p| File.join(@aruba.aruba.current_directory, p) } }

      before do
        Array(path).each { |p| Aruba.platform.mkdir p }
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

  describe '#absolute?' do
    let(:name) { @file_name }
    let(:path) { File.expand_path(File.join(@aruba.aruba.current_directory, name)) }

    context 'when given an absolute path' do
      it { expect(@aruba).to be_absolute(path) }
    end

    context 'when given a relative path' do
      it { expect(@aruba).not_to be_absolute(name) }
    end
  end

  describe '#relative?' do
    let(:name) { @file_name }
    let(:path) { File.expand_path(File.join(@aruba.aruba.current_directory, name)) }

    context 'when given an absolute path' do
      it { expect(@aruba).not_to be_relative(path) }
    end

    context 'when given a relative path' do
      it { expect(@aruba).to be_relative(name) }
    end
  end

  describe '#exist?' do
    context 'when given a file' do
      let(:name) { @file_name }
      let(:path) { @file_path }

      context 'when it exists' do
        before :each do
          Aruba.platform.write_file(path, '')
        end

        it { expect(@aruba).to be_exist(name) }
      end

      context 'when it does not exist' do
        it { expect(@aruba).not_to be_exist(name) }
      end
    end

    context 'when given a directory' do
      let(:name) { 'test.d' }
      let(:path) { File.join(@aruba.aruba.current_directory, name) }

      context 'when it exists' do
        before :each do
          Aruba.platform.mkdir(path)
        end

        it { expect(@aruba).to be_exist(name) }
      end

      context 'when it does not exist' do
        it { expect(@aruba).not_to be_exist(name) }
      end
    end
  end

  describe '#file?' do
    context 'when given a file' do
      let(:name) { @file_name }
      let(:path) { @file_path }

      context 'when it exists' do
        before :each do
          Aruba.platform.write_file(path, '')
        end

        it { expect(@aruba).to be_file(name) }
      end

      context 'when does not exist' do
        it { expect(@aruba).not_to be_file(name) }
      end
    end

    context 'when given a directory' do
      let(:name) { 'test.d' }
      let(:path) { File.join(@aruba.aruba.current_directory, name) }

      context 'when it exists' do
        before :each do
          Aruba.platform.mkdir(path)
        end

        it { expect(@aruba).not_to be_file(name) }
      end

      context 'when it does not exist' do
        it { expect(@aruba).not_to be_file(name) }
      end
    end
  end

  describe '#directory?' do
    context 'when given a file' do
      let(:name) { @file_name }
      let(:path) { @file_path }

      context 'when it exists' do
        before :each do
          Aruba.platform.write_file(path, '')
        end

        it { expect(@aruba).not_to be_directory(name) }
      end

      context 'when it does not exist' do
        it { expect(@aruba).not_to be_directory(name) }
      end
    end

    context 'when given a directory' do
      let(:name) { 'test.d' }
      let(:path) { File.join(@aruba.aruba.current_directory, name) }

      context 'when it exists' do
        before :each do
          Aruba.platform.mkdir(path)
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
            Aruba.platform.mkdir(File.join(@aruba.aruba.current_directory, source))
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
              Aruba.platform.mkdir(File.join(@aruba.aruba.current_directory, destination))
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
        it { expect { @aruba.copy source, destination }.to raise_error ArgumentError }
      end
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

  describe '#chmod' do
    def actual_permissions
      format("%o" , File::Stat.new(file_path).mode )[-4,4]
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
      @aruba.chmod(permissions, file_name)
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

  context "#with_file_content" do
    before :each do
      @aruba.write_file(@file_name, "foo bar baz")
    end

    it "passes the given file's full content to the given block" do
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
  end

  describe '#create_directory' do
    before(:each) do
      @directory_name = 'test_dir'
      @directory_path = File.join(@aruba.aruba.current_directory, @directory_name)
    end

    it 'creates a directory' do
      @aruba.create_directory @directory_name
      expect(File.exist?(File.expand_path(@directory_path))).to be_truthy
    end
  end

  describe '#read' do
    let(:name) { 'test.txt' }
    let(:path) { File.join(@aruba.aruba.current_directory, name) }
    let(:content) { 'asdf' }

    before :each do
      @aruba.set_environment_variable 'HOME', File.expand_path(@aruba.aruba.current_directory)
    end

    context 'when does not exist' do
      it { expect { @aruba.read(name) }.to raise_error ArgumentError }
    end

    context 'when it exists' do
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

        before do
          Array(path).each { |p| Aruba.platform.mkdir p }
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
      @aruba.set_environment_variable 'HOME', File.expand_path(@aruba.aruba.current_directory)
    end

    context 'when does not exist' do
      it { expect { @aruba.list(name) }.to raise_error ArgumentError }
    end

    context 'when it exists' do
      context 'when file' do
        let(:name) { 'test.txt' }

        before :each do
          File.open(File.expand_path(path), 'w') { |f| f << content }
        end

        context 'when normal file' do
          it { expect { @aruba.list(name) }.to raise_error ArgumentError }
        end
      end

      context 'when directory' do
        before do
          Array(path).each { |p| Aruba.platform.mkdir p }
          Array(content).each { |p| Aruba.platform.mkdir File.join(path, p) }
        end

        context 'when has subdirectories' do
          context 'when is simple path' do
            let(:existing_files) { @aruba.list(name) }
            let(:expected_files) { content.map { |c| File.join(name, c) }.sort }

            it { expect(expected_files - existing_files).to be_empty }
          end

          context 'when path contains ~' do
            let(:string) { random_string }
            let(:name) { File.join('~', string) }
            let(:path) { File.join(@aruba.aruba.current_directory, string) }

            let(:existing_files) { @aruba.list(name) }
            let(:expected_files) { content.map { |c| File.join(string, c) } }

            it { expect(expected_files - existing_files).to be_empty }
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
    let(:name) { 'test.txt' }
    let(:path) { File.join(@aruba.aruba.current_directory, name) }
    let(:options) { {} }

    before :each do
      @aruba.set_environment_variable 'HOME', File.expand_path(@aruba.aruba.current_directory)
    end

    context 'when given a file' do
      context 'when it exists' do
        before do
          Array(path).each { |p| File.open(File.expand_path(p), 'w') { |f| f << "" } }

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

      context 'when it does not exist' do
        before do
          @aruba.remove(name, options)
        end

        context 'when forced to delete file' do
          let(:options) { { :force => true } }

          it_behaves_like 'a non-existing file'
        end
      end
    end

    context 'when given a directory' do
      let(:name) { 'test.d' }

      context 'when it exists' do
        before do
          Array(path).each { |p| Aruba.platform.mkdir p }
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

      context 'when it does not exist' do
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
end
