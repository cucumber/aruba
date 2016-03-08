require 'aruba/platform'

require 'aruba/extensions/string/strip'

require 'aruba/aruba_path'

Aruba.platform.require_matching_files('../matchers/file/*.rb', __FILE__)
Aruba.platform.require_matching_files('../matchers/directory/*.rb', __FILE__)
Aruba.platform.require_matching_files('../matchers/path/*.rb', __FILE__)

# Aruba
module Aruba
  # Api
  module Api
    # Filesystem methods
    module Filesystem
      # Check if file or directory exist
      #
      # @param [String] file_or_directory
      #   The file/directory which should exist
      def exist?(file_or_directory)
        Aruba.platform.exist? expand_path(file_or_directory)
      end

      # Check if file exist and is file
      #
      # @param [String] file
      #   The file/directory which should exist
      def file?(file)
        Aruba.platform.file? expand_path(file)
      end

      # Check if directory exist and is directory
      #
      # @param [String] file
      #   The file/directory which should exist
      def directory?(file)
        Aruba.platform.directory? expand_path(file)
      end

      # Check if file exist and is executable
      #
      # @param [String] file
      #   The file which should exist
      def executable?(path)
        path = expand_path(path)

        Aruba.platform.file?(path) && Aruba.platform.executable?(path)
      end

      # Check if path is absolute
      #
      # @return [TrueClass, FalseClass]
      #   Result of check
      def absolute?(path)
        ArubaPath.new(path).absolute?
      end

      # Check if path is relative
      #
      # @return [TrueClass, FalseClass]
      #   Result of check
      def relative?(path)
        ArubaPath.new(path).relative?
      end

      # Return all existing paths (directories, files) in current dir
      #
      # @return [Array]
      #   List of files and directories
      def all_paths
        list('.').map { |p| expand_path(p) }
      end

      # Return all existing files in current directory
      #
      # @return [Array]
      #   List of files
      def all_files
        list('.').select { |p| file? p }.map { |p| expand_path(p) }
      end

      # Return all existing directories in current directory
      #
      # @return [Array]
      #   List of files
      def all_directories
        list('.').select { |p| directory? p }.map { |p| expand_path(p) }
      end

      # Create directory object
      #
      # @return [Dir]
      #   The directory object
      def directory(path)
        fail ArgumentError, %(Path "#{name}" does not exist.) unless exist? name

        Dir.new(expand_path(path))
      end

      # Return content of directory
      #
      # @return [Array]
      #   The content of directory
      def list(name)
        fail ArgumentError, %(Path "#{name}" does not exist.) unless exist? name
        fail ArgumentError, %(Only directories are supported. Path "#{name}" is not a directory.) unless directory? name

        existing_files            = Dir.glob(expand_path(File.join(name, '**', '*')))
        current_working_directory = ArubaPath.new(expand_path('.'))

        existing_files.map { |d| ArubaPath.new(d).relative_path_from(current_working_directory).to_s }
      end

      # Return content of file
      #
      # @return [Array]
      #   The content of file, without "\n" or "\r\n" at the end. To rebuild the file use `content.join("\n")`
      def read(name)
        fail ArgumentError, %(Path "#{name}" does not exist.) unless exist? name
        fail ArgumentError, %(Only files are supported. Path "#{name}" is not a file.) unless file? name

        File.readlines(expand_path(name)).map(&:chomp)
      end

      # Create a file with given content
      #
      # The method does not check if file already exists. If the file name is a
      # path the method will create all neccessary directories.
      #
      # @param [String] file_name
      #   The name of the file
      #
      # @param [String] file_content
      #   The content which should be written to the file
      def write_file(name, content)
        Aruba.platform.create_file(expand_path(name), content, false)

        self
      end

      # Create an empty file
      #
      # @param [String] file_name
      #   The name of the file
      def touch(*args)
        args = args.flatten

        options = if args.last.kind_of? Hash
                    args.pop
                  else
                    {}
                  end

        args.each { |p| create_directory(File.dirname(p)) }

        Aruba.platform.touch(args.map { |p| expand_path(p) }, options)

        self
      end

      # Copy a file and/or directory
      #
      # @param [String, Array] source
      #   A single file or directory, multiple files or directories or multiple
      #   files and directories. If multiple sources are given the destination
      #   needs to be a directory
      #
      # @param [String] destination
      #   A file or directory name. If multiple sources are given the destination
      #   needs to be a directory
      #
      # rubocop:disable Metrics/CyclomaticComplexity
      # def copy(*source, destination)
      def copy(*args)
        args = args.flatten
        destination = args.pop
        source = args

        source.each do |s|
          raise ArgumentError, %(The following source "#{s}" does not exist.) unless exist? s
        end

        raise ArgumentError, "Using a fixture as destination (#{destination}) is not supported" if destination.start_with? aruba.config.fixtures_path_prefix
        raise ArgumentError, "Multiples sources can only be copied to a directory" if source.count > 1 && exist?(destination) && !directory?(destination)

        source_paths     = source.map { |f| expand_path(f) }
        destination_path = expand_path(destination)

        if source_paths.count > 1
          Aruba.platform.mkdir(destination_path)
        else
          Aruba.platform.mkdir(File.dirname(destination_path))
          source_paths = source_paths.first
        end

        Aruba.platform.cp source_paths, destination_path

        self
      end
      # rubocop:enable Metrics/CyclomaticComplexity

      # Move a file and/or directory
      #
      # @param [String, Array] source
      #   A single file or directory, multiple files or directories or multiple
      #   files and directories. If multiple sources are given the destination
      #   needs to be a directory
      #
      # @param [String] destination
      #   A file or directory name. If multiple sources are given the destination
      #   needs to be a directory
      #
      # rubocop:disable Metrics/CyclomaticComplexity
      # rubocop:disable Metrics/MethodLength
      def move(*args)
        args = args.flatten
        destination = args.pop
        source = args

        source.each do |s|
          raise ArgumentError, "Using a fixture as source (#{source}) is not supported" if s.start_with? aruba.config.fixtures_path_prefix
        end

        raise ArgumentError, "Using a fixture as destination (#{destination}) is not supported" if destination.start_with? aruba.config.fixtures_path_prefix

        source.each do |s|
          raise ArgumentError, %(The following source "#{s}" does not exist.) unless exist? s
        end

        raise ArgumentError, "Multiple sources can only be copied to a directory" if source.count > 1 && exist?(destination) && !directory?(destination)

        source_paths     = source.map { |f| expand_path(f) }
        destination_path = expand_path(destination)

        if source_paths.count > 1
          Aruba.platform.mkdir(destination_path)
        else
          Aruba.platform.mkdir(File.dirname(destination_path))
          source_paths = source_paths.first
        end

        Aruba.platform.mv source_paths, destination_path

        self
      end
      # rubocop:enable Metrics/MethodLength
      # rubocop:enable Metrics/CyclomaticComplexity

      # Create a file with the given size
      #
      # The method does not check if file already exists. If the file name is a
      # path the method will create all neccessary directories.
      #
      # @param [String] file_name
      #   The name of the file
      #
      # @param [Integer] file_size
      #   The size of the file
      def write_fixed_size_file(name, size)
        Aruba.platform.create_fixed_size_file(expand_path(name), size, false)

        self
      end

      # Create a file with given content
      #
      # The method does check if file already exists and fails if the file is
      # missing. If the file name is a path the method will create all neccessary
      # directories.
      def overwrite_file(name, content)
        Aruba.platform.create_file(expand_path(name), content, true)

        self
      end

      # Change file system  permissions of file
      #
      # @param [Octal] mode
      #   File system mode, eg. 0755
      #
      # @param [String] file_name
      #   Name of file to be modified. This file needs to be present to succeed
      def chmod(*args)
        args = args.flatten

        options = if args.last.kind_of? Hash
                    args.pop
                  else
                    {}
                  end

        mode = args.shift
        mode = if mode.kind_of? String
                 mode.to_i(8)
               else
                 mode
               end

        args.each { |p| raise "Expected #{p} to be present" unless exist?(p) }
        paths = args.map { |p| expand_path(p) }

        Aruba.platform.chmod(mode, paths, options)

        self
      end

      # Append data to file
      #
      # @param [String] file_name
      #   The name of the file to be used
      #
      # @param [String] file_content
      #   The content which should be appended to file
      def append_to_file(file_name, file_content)
        file_name = expand_path(file_name)

        Aruba.platform.mkdir(File.dirname(file_name))
        File.open(file_name, 'a') { |f| f << file_content }
      end

      # Create a directory in current directory
      #
      # @param [String] directory_name
      #   The name of the directory which should be created
      def create_directory(directory_name)
        Aruba.platform.mkdir expand_path(directory_name)

        self
      end

      # Remove file or directory
      #
      # @param [Array, String] name
      #   The name of the file / directory which should be removed
      def remove(*args)
        args = args.flatten

        options = if args.last.kind_of? Hash
                    args.pop
                  else
                    {}
                  end

        args = args.map { |p| expand_path(p) }

        Aruba.platform.rm(args, options)
      end

      # Read content of file and yield the content to block
      #
      # @param [String) file
      #   The name of file which should be read from
      #
      # @yield
      #   Pass the content of the given file to this block
      def with_file_content(file, &block)
        expect(file).to be_an_existing_path

        content = read(file).join("\n")

        yield(content)
      end

      # Calculate disk usage for file(s) and/or directories
      #
      # It shows the disk usage for a single file/directory. If multiple paths
      # are given, it sum their size up.
      #
      # @param [Array, Path] paths
      #   The paths
      #
      # @result [FileSize]
      #   Bytes on disk
      def disk_usage(*paths)
        expect(paths.flatten).to Aruba::Matchers.all be_an_existing_path

        Aruba.platform.determine_disk_usage paths.flatten.map { |p| ArubaPath.new(expand_path(p)) }, aruba.config.physical_block_size
      end

      # Get size of file
      #
      # @return [Numeric]
      #   The size of the file
      def file_size(name)
        expect(name).to be_an_existing_file

        Aruba.platform.determine_file_size expand_path(name)
      end
    end
  end
end
