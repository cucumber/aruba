require 'aruba/platform'
require 'aruba/extensions/string/strip'
require 'aruba/creators/aruba_file_creator'
require 'aruba/creators/aruba_fixed_size_file_creator'

Aruba::Platform.require_matching_files('../matchers/file/*.rb', __FILE__)
Aruba::Platform.require_matching_files('../matchers/directory/*.rb', __FILE__)
Aruba::Platform.require_matching_files('../matchers/path/*.rb', __FILE__)

module Aruba
  module Api
    module Filesystem
      # Check if file or directory exist
      #
      # @param [String] file_or_directory
      #   The file/directory which should exist
      def exist?(file_or_directory)
        Aruba::Platform.exist? expand_path(file_or_directory)
      end

      # Check if file exist and is file
      #
      # @param [String] file
      #   The file/directory which should exist
      def file?(file)
        Aruba::Platform.file? expand_path(file)
      end

      # Check if directory exist and is directory
      #
      # @param [String] file
      #   The file/directory which should exist
      def directory?(file)
        Aruba::Platform.directory? expand_path(file)
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
        Creators::ArubaFileCreator.new.write(expand_path(name), content, false)

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

        Aruba::Platform.touch(args.map { |p| expand_path(p) }, options)

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
          Aruba::Platform.mkdir(destination_path)
        else
          Aruba::Platform.mkdir(File.dirname(destination_path))
          source_paths = source_paths.first
        end

        Aruba::Platform.cp source_paths, destination_path

        self
      end
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
        Creators::ArubaFixedSizeFileCreator.new.write(expand_path(name), size, false)

        self
      end

      # Create a file with given content
      #
      # The method does check if file already exists and fails if the file is
      # missing. If the file name is a path the method will create all neccessary
      # directories.
      def overwrite_file(name, content)
        Creators::ArubaFileCreator.new.write(expand_path(name), content, true)

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

        Aruba::Platform.chmod(mode, paths, options)

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

        Aruba::Platform.mkdir(File.dirname(file_name))
        File.open(file_name, 'a') { |f| f << file_content }
      end

      # Create a directory in current directory
      #
      # @param [String] directory_name
      #   The name of the directory which should be created
      def create_directory(directory_name)
        Aruba::Platform.mkdir expand_path(directory_name)

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

        Aruba::Platform.rm(args, options)
      end

      # Read content of file and yield the content to block
      #
      # @param [String) file
      #   The name of file which should be read from
      #
      # @yield
      #   Pass the content of the given file to this block
      def with_file_content(file, &block)
        stop_processes!

        content = read(file).join("\n")

        yield(content)
      end
    end
  end
end
