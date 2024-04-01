require "spec_helper"
require "aruba/api"

RSpec.describe Aruba::Api::Filesystem do
  include_context "uses aruba API"

  let(:name) { @file_name }
  let(:path) { @file_path }
  let(:dir_name) { "test.d" }
  let(:dir_path) { @aruba.expand_path(dir_name) }

  describe "#append_lines_to_file" do
    it "inserts a newline if existing file does not end in one" do
      Aruba.platform.write_file(path, "foo\nbar")
      append_lines_to_file(name, "baz")
      expect(File.read(path)).to eq "foo\nbar\nbaz"
    end

    it "does not insert a newline if the existing file ends in one" do
      Aruba.platform.write_file(path, "foo\nbar\n")
      append_lines_to_file(name, "baz")
      expect(File.read(path)).to eq "foo\nbar\nbaz"
    end
  end

  describe "#all_paths" do
    context "when file exists" do
      before do
        Aruba.platform.write_file(path, "")
      end

      it { expect(all_paths).to include expand_path(name) }
    end

    context "when directory exists" do
      let(:name) { "test_dir" }
      let(:path) { File.join(@aruba.aruba.current_directory, name) }

      before do
        Aruba.platform.mkdir(path)
      end

      it { expect(all_paths).to include expand_path(name) }
    end

    context "when nothing exists" do
      it { expect(all_paths).to eq [] }
    end
  end

  describe "#all_files" do
    context "when file exists" do
      before do
        Aruba.platform.write_file(path, "")
      end

      it { expect(all_files).to include expand_path(name) }
    end

    context "when directory exists" do
      let(:name) { "test_dir" }
      let(:path) { File.join(@aruba.aruba.current_directory, name) }

      before do
        Aruba.platform.mkdir(path)
      end

      it { expect(all_files).to eq [] }
    end

    context "when nothing exists" do
      it { expect(all_files).to eq [] }
    end
  end

  describe "#all_directories" do
    context "when file exists" do
      before do
        Aruba.platform.write_file(path, "")
      end

      it { expect(all_directories).to eq [] }
    end

    context "when directory exists" do
      let(:name) { "test_dir" }
      let(:path) { File.join(@aruba.aruba.current_directory, name) }

      before do
        Aruba.platform.mkdir(path)
      end

      it { expect(all_directories).to include expand_path(name) }
    end

    context "when nothing exists" do
      it { expect(all_directories).to eq [] }
    end
  end

  describe "#file_size" do
    let(:size) { file_size(name) }

    context "when file exists" do
      before do
        File.open(path, "w") { |f| f.print "a" }
      end

      it { expect(size).to eq 1 }
    end

    context "when file does not exist" do
      let(:name) { "non_existing_file" }

      it { expect { size }.to raise_error RSpec::Expectations::ExpectationNotMetError }
    end
  end

  describe "#touch" do
    context "when touching a file that does not exist" do
      it "creates an empty file in an existing directory" do
        @aruba.touch(name)

        aggregate_failures do
          expect(File.size(path)).to eq 0
          expect(File.file?(path)).to be true
        end
      end

      it "creates an empty file in a non-existing directory" do
        name = "directory/test"
        path = File.join(@aruba.aruba.current_directory, name)

        @aruba.touch(name)
        expect(File.file?(path)).to be true
      end

      it "creates a file relative to home if name includes ~" do
        string = random_string
        name = File.join("~", string)
        path = File.join(@aruba.aruba.config.home_directory, string)

        @aruba.touch(name)
        expect(File.file?(path)).to be true
      end

      it "sets mtime when passed as an option" do
        time = Time.parse("2014-01-01 10:00:00")

        @aruba.touch(name, mtime: time)
        aggregate_failures do
          expect(File.file?(path)).to be true
          expect(File.mtime(path)).to eq time
        end
      end

      it "creates multiple files when multiple names are given" do
        names = %w(file1 file2 file3)

        @aruba.touch(names)

        paths = names.map { |name| File.join(@aruba.aruba.current_directory, name) }
        aggregate_failures do
          paths.each do |path|
            expect(File.file?(path)).to be true
          end
        end
      end
    end

    context "when touching an existing directory" do
      let(:name) { %w(directory1) }
      let(:path) { File.join(@aruba.aruba.current_directory, name) }

      before do
        Aruba.platform.mkdir path
      end

      it "leaves the directory a directory" do
        @aruba.touch(name)
        expect(File.directory?(path)).to be true
      end

      it "sets the mtime if requested" do
        time = Time.parse("2014-01-01 10:00:00")
        @aruba.touch(name, mtime: time)

        aggregate_failures do
          expect(File.directory?(path)).to be true
          expect(File.mtime(path)).to eq time
        end
      end
    end
  end

  describe "#absolute?" do
    context "when is absolute path" do
      it { expect(@aruba).to be_absolute(path) }
    end

    context "when is relative path" do
      it { expect(@aruba).not_to be_absolute(name) }
    end
  end

  describe "#relative?" do
    context "when given an absolute path" do
      it { expect(@aruba).not_to be_relative(path) }
    end

    context "when given a relative path" do
      it { expect(@aruba).to be_relative(name) }
    end
  end

  describe "#exist?" do
    context "when given a file" do
      it "returns true if the file exists" do
        Aruba.platform.write_file(path, "")

        expect(@aruba.exist?(name)).to be true
      end

      it "returns false if the file does not exist" do
        expect(@aruba.exist?(name)).to be false
      end
    end

    context "when given a directory" do
      it "returns true if the directory exists" do
        Aruba.platform.mkdir(dir_path)

        expect(@aruba.exist?(dir_name)).to be true
      end

      it "returns false if the directory does not exist" do
        expect(@aruba.exist?(dir_name)).to be false
      end
    end
  end

  describe "#file?" do
    context "when given a file" do
      context "when it exists" do
        before do
          Aruba.platform.write_file(path, "")
        end

        it { expect(@aruba).to be_file(name) }
      end

      context "when does not exist" do
        it { expect(@aruba).not_to be_file(name) }
      end
    end

    context "when given a directory" do
      let(:name) { "test.d" }
      let(:path) { File.join(@aruba.aruba.current_directory, name) }

      context "when it exists" do
        before do
          Aruba.platform.mkdir(path)
        end

        it { expect(@aruba).not_to be_file(name) }
      end

      context "when does not exist" do
        it { expect(@aruba).not_to be_file(name) }
      end
    end
  end

  describe "#directory?" do
    context "when given a file" do
      context "when it exists" do
        before do
          Aruba.platform.write_file(path, "")
        end

        it { expect(@aruba).not_to be_directory(name) }
      end

      context "when does not exist" do
        it { expect(@aruba).not_to be_directory(name) }
      end
    end

    context "when given a directory" do
      context "when it exists" do
        before do
          Aruba.platform.mkdir(dir_path)
        end

        it { expect(@aruba).to be_directory(dir_name) }
      end

      context "when does not exist" do
        it { expect(@aruba).not_to be_directory(dir_name) }
      end
    end
  end

  describe "#copy" do
    let(:source) { "file.txt" }
    let(:destination) { "file1.txt" }

    context "when source is existing" do
      context "when destination is non-existing" do
        context "when source is file" do
          before do
            create_test_files(source)
            @aruba.copy source, destination
          end

          context "when source is plain file" do
            it { expect(destination).to be_an_existing_file }
          end

          context 'when source is contains "~" in path' do
            let(:source) { "~/file.txt" }

            it { expect(destination).to be_an_existing_file }
          end

          context "when source is fixture" do
            let(:source) { "%/copy/file.txt" }
            let(:destination) { "file.txt" }

            it { expect(destination).to be_an_existing_file }
          end

          context "when source is list of files" do
            let(:source) { %w(file1.txt file2.txt file3.txt) }
            let(:destination) { "file.d" }
            let(:destination_files) { source.map { |s| File.join(destination, s) } }

            it { expect(destination_files).to all be_an_existing_file }
          end
        end

        context "when source is directory" do
          let(:source) { "src.d" }
          let(:destination) { "dst.d" }

          before do
            Aruba.platform.mkdir(File.join(@aruba.aruba.current_directory, source))
            @aruba.copy source, destination
          end

          context "when source is single directory" do
            it { expect(destination).to be_an_existing_directory }
          end

          context "when source is nested directory" do
            let(:source) { "src.d/subdir.d" }
            let(:destination) { "dst.d/" }

            it { expect(destination).to be_an_existing_directory }
          end
        end
      end

      context "when destination is existing" do
        context "when source is list of files" do
          before { create_test_files(source) }

          context "when destination is directory" do
            let(:source) { %w(file1.txt file2.txt file3.txt) }
            let(:destination) { "file.d" }
            let(:destination_files) { source.map { |s| File.join(destination, s) } }

            before do
              Aruba.platform.mkdir(File.join(@aruba.aruba.current_directory, destination))
              @aruba.copy source, destination
            end

            it { expect(destination_files).to all be_an_existing_file }
          end

          context "when destination is not a directory" do
            let(:source) { %w(file1.txt file2.txt file3.txt) }
            let(:destination) { "file.txt" }
            let(:error_message) { "Multiples sources can only be copied to a directory" }

            before { create_test_files(destination) }

            it "raises an appropriate error" do
              expect { @aruba.copy source, destination }
                .to raise_error ArgumentError, error_message
            end
          end

          context "when a source is the same like destination" do
            let(:source) { "file1.txt" }
            let(:destination) { "file1.txt" }

            before { create_test_files(source) }

            it "raises an appropriate error" do
              src_path = File.expand_path(File.join(@aruba.aruba.current_directory, source))
              dest_path = File.expand_path(File.join(@aruba.aruba.current_directory,
                                                     destination))
              expected_message = %(same file: #{src_path} and #{dest_path})
              expect { @aruba.copy source, destination }
                .to raise_error ArgumentError, expected_message
            end
          end

          context "when a fixture is destination" do
            let(:source) { "%/copy/file.txt" }
            let(:destination) { "%/copy/file.txt" }
            let(:error_message) do
              "Using a fixture as destination (#{destination}) is not supported"
            end

            it "raises an appropriate error" do
              expect { @aruba.copy source, destination }
                .to raise_error ArgumentError, error_message
            end
          end
        end
      end

      context "when source is non-existing" do
        it { expect { @aruba.copy source, destination }.to raise_error ArgumentError }
      end
    end
  end

  describe "#write_file" do
    it "writes file" do
      @aruba.write_file(name, "")

      expect(File.exist?(path)).to be true
    end
  end

  describe "#write_fixed_size_file" do
    let(:file_size) { @file_size }

    it "writes a fixed sized file" do
      @aruba.write_fixed_size_file(name, file_size)
      expect(File.exist?(path)).to be true
      expect(File.size(path)).to eq file_size
    end

    it "works with ~ in path name" do
      file_path = File.join("~", random_string)

      @aruba.with_environment "HOME" => File.expand_path(aruba.current_directory) do
        @aruba.write_fixed_size_file(file_path, file_size)

        expect(File.exist?(File.expand_path(file_path))).to be true
        expect(File.size(File.expand_path(file_path))).to eq file_size
      end
    end
  end

  describe "#chmod" do
    def actual_permissions
      format("%o", File::Stat.new(path).mode)[-4, 4]
    end

    let(:permissions) { "0644" }

    before do
      @aruba.set_environment_variable "HOME", File.expand_path(@aruba.aruba.current_directory)
      File.open(path, "w") { |f| f << "" }
      @aruba.chmod(permissions, name)
    end

    context "when file exists" do
      context "and permissions are given as string" do
        it { expect(actual_permissions).to eq("0644") }
      end

      context "and permissions are given as octal number" do
        let(:permissions) { 0o644 }

        it { expect(actual_permissions).to eq("0644") }
      end

      context "and path has ~ in it" do
        let(:basename) { random_string }
        let(:name) { File.join("~", basename) }
        let(:path) { File.join(@aruba.aruba.current_directory, basename) }

        it { expect(actual_permissions).to eq("0644") }
      end
    end
  end

  describe "#with_file_content" do
    before do
      @aruba.write_file(name, "foo bar baz")
    end

    it "checks the given file's full content against the expectations in the passed block" do
      @aruba.with_file_content name do |full_content|
        expect(full_content).to eq "foo bar baz"
      end
    end

    it "works with ~ in path name" do
      file_path = File.join("~", random_string)

      @aruba.with_environment "HOME" => File.expand_path(aruba.current_directory) do
        @aruba.write_file(file_path, "foo bar baz")

        @aruba.with_file_content file_path do |full_content|
          expect(full_content).to eq "foo bar baz"
        end
      end
    end

    context "checking the file's content against the expectations in the block" do
      it "is successful when the inner expectations match" do
        expect do
          @aruba.with_file_content name do |full_content|
            expect(full_content).to     match(/foo/)
            expect(full_content).not_to match(/zoo/)
          end
        end.not_to raise_error
      end

      it "raises ExpectationNotMetError when the inner expectations don't match" do
        expect do
          @aruba.with_file_content name do |full_content|
            expect(full_content).to     match(/zoo/)
            expect(full_content).not_to match(/foo/)
          end
        end.to raise_error RSpec::Expectations::ExpectationNotMetError
      end
    end
  end

  describe "#create_directory" do
    before do
      @directory_name = "test_dir"
      @directory_path = File.join(@aruba.aruba.current_directory, @directory_name)
    end

    it "creates a directory" do
      @aruba.create_directory @directory_name
      expect(File).to exist(File.expand_path(@directory_path))
    end
  end

  describe "#read" do
    let(:name) { "test.txt" }
    let(:path) { File.join(@aruba.aruba.current_directory, name) }
    let(:content) { "asdf" }

    before do
      @aruba.set_environment_variable "HOME", File.expand_path(@aruba.aruba.current_directory)
    end

    context "when does not exist" do
      it { expect { @aruba.read(name) }.to raise_error ArgumentError }
    end

    context "when it exists" do
      context "when file" do
        before do
          File.open(File.expand_path(path), "w") { |f| f << content }
        end

        context "when normal file" do
          it { expect(@aruba.read(name)).to eq [content] }
        end

        context "when binary file" do
          let(:content) { "\u0000" }

          it { expect(@aruba.read(name)).to eq [content] }
        end

        context "when is empty file" do
          let(:content) { "" }

          it { expect(@aruba.read(name)).to eq [] }
        end

        context "when path contains ~" do
          let(:string) { random_string }
          let(:name) { File.join("~", string) }
          let(:path) { File.join(@aruba.aruba.current_directory, string) }

          it { expect(@aruba.read(name)).to eq [content] }
        end
      end

      context "when directory" do
        let(:name) { "test.d" }

        before do
          Aruba.platform.mkdir path
        end

        it { expect { @aruba.read(name) }.to raise_error ArgumentError }
      end
    end
  end

  describe "#list" do
    let(:name) { "test.d" }
    let(:content) { %w(subdir.1.d subdir.2.d) }
    let(:path) { File.join(@aruba.aruba.current_directory, name) }

    before do
      @aruba.set_environment_variable "HOME", File.expand_path(@aruba.aruba.current_directory)
    end

    context "when does not exist" do
      it { expect { @aruba.list(name) }.to raise_error ArgumentError }
    end

    context "when it exists" do
      context "when file" do
        let(:name) { "test.txt" }

        before do
          File.open(File.expand_path(path), "w") { |f| f << content }
        end

        context "when normal file" do
          it { expect { @aruba.list(name) }.to raise_error ArgumentError }
        end
      end

      context "when directory" do
        before do
          Aruba.platform.mkdir path
          Array(content).each { |it| Aruba.platform.mkdir File.join(path, it) }
        end

        context "when has subdirectories" do
          context "when is simple path" do
            let(:existing_files) { @aruba.list(name) }
            let(:expected_files) { content.map { |c| File.join(name, c) }.sort }

            it { expect(expected_files - existing_files).to be_empty }
          end

          context "when path contains ~" do
            let(:string) { random_string }
            let(:name) { File.join("~", string) }
            let(:path) { File.join(@aruba.aruba.current_directory, string) }

            let(:existing_files) { @aruba.list(name) }
            let(:expected_files) { content.map { |c| File.join(string, c) } }

            it { expect(expected_files - existing_files).to be_empty }
          end
        end

        context "when has no subdirectories" do
          let(:content) { [] }

          it { expect(@aruba.list(name)).to eq [] }
        end
      end
    end
  end

  describe "#remove" do
    let(:options) { {} }

    context "when given an existing file" do
      it "removes a single file" do
        name = "test.txt"
        path = File.join(@aruba.aruba.current_directory, name)

        File.write(File.expand_path(path), "foo")
        @aruba.remove(name)

        expect(File.exist?(path)).to be false
      end

      it "removes multiple files" do
        names = %w(file1 file2 file3)
        paths = names.map { |it| File.join(@aruba.aruba.current_directory, it) }
        paths.each { |it| File.write(File.expand_path(it), "foo #{it}") }

        @aruba.remove(names)
        aggregate_failures do
          paths.each do |path|
            expect(File.exist?(path)).to be false
          end
        end
      end

      it "interprets ~ as referencing the aruba home directory" do
        string = random_string
        name = File.join("~", string)
        path = File.join(@aruba.aruba.config.home_directory, string)
        File.write(File.expand_path(path), "foo")

        @aruba.remove(name)

        expect(File.exist?(path)).to be false
      end
    end

    context "when given an existing directory" do
      it "removes a single directory" do
        name = "test.d"
        path = File.join(@aruba.aruba.current_directory, name)
        Aruba.platform.mkdir path

        @aruba.remove(name)

        expect(File.exist?(path)).to be false
      end

      it "removes multiple directories" do
        names = %w(directory1 directory2 directory3)
        paths = names.map { |it| File.join(@aruba.aruba.current_directory, it) }
        paths.each { |path| Aruba.platform.mkdir path }

        @aruba.remove(names)
        aggregate_failures do
          paths.each do |path|
            expect(File.exist?(path)).to be false
          end
        end
      end

      it "interprets ~ as referencing the aruba home directory" do
        string = random_string
        name = File.join("~", string)
        path = File.join(@aruba.aruba.config.home_directory, string)
        Aruba.platform.mkdir path

        @aruba.remove(name)

        expect(File.exist?(path)).to be false
      end
    end

    context "when given an item that does not exist" do
      it "raises an error" do
        name = "missing"
        expect { @aruba.remove(name) }.to raise_error Errno::ENOENT
      end

      it "raises no error when forced to delete the file" do
        name = "missing"
        path = File.join(@aruba.aruba.current_directory, name)

        aggregate_failures do
          expect { @aruba.remove(name, force: true) }.not_to raise_error
          expect(File.exist?(path)).to be false
        end
      end
    end
  end
end
