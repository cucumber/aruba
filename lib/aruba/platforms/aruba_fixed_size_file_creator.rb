# frozen_string_literal: true

# Aruba
module Aruba
  # Platforms
  module Platforms
    # Create files with fixed size
    #
    # This class is not meant to be used directly by users.
    #
    # It uses a single null byte as content and really creates so called sparse
    # files.
    #
    # @private
    class ArubaFixedSizeFileCreator
      # Write File
      #
      # @param [String] path
      #   The path to write content to
      #
      # @param [Numeric] size
      #   The size of the file
      #
      # @param [Boolean] check_presence (false)
      #   Check if file exist
      def call(path, size, check_presence)
        if check_presence && !Aruba.platform.file?(path)
          raise "Expected #{path} to be present"
        end

        Aruba.platform.mkdir(File.dirname(path))

        File.open(path, 'wb') do |f|
          f.seek(size - 1)
          f.write("\0")
        end

        self
      end
    end
  end
end
