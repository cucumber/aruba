# frozen_string_literal: true

# Aruba
module Aruba
  # Platforms
  module Platforms
    # Normal File Creator
    # This class is not meant to be used directly by users.
    #
    # @private
    class ArubaFileCreator
      # Write File
      #
      # @param [String] path
      #   The path to write content to
      #
      # @param [Object] content
      #   The content of the file
      #
      # @param [Boolean] check_presence (false)
      #   Check if file exist
      def call(path, content, check_presence = false)
        if check_presence && !Aruba.platform.file?(path)
          raise "Expected #{path} to be present"
        end

        Aruba.platform.mkdir(File.dirname(path))

        File.write(path, content)

        self
      end
    end
  end
end
