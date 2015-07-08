module Aruba
  # Create things to make aruba work
  module Creators
    # Create files with fixed size
    #
    # This class is not meant to be used directly by users.
    #
    # It uses a single null byte as content and really creates so called sparse
    # files.
    class ArubaFixedSizeFileCreator
      # Write File
      #
      # @param [String] path
      #   The path to write content to
      #
      # @param [Numeric] size
      #   The size of the file
      #
      # @param [TrueClass, FalseClass] check_presence (false)
      #   Check if file exist
      def write(path, size, check_presence)
        fail "Expected #{path} to be present" if check_presence && !Aruba::Platform.file?(path)

        Aruba::Platform.mkdir(File.dirname(path))

        File.open(path, "wb"){ |f| f.seek(size - 1); f.write("\0") }

        self
      end
    end
  end
end
