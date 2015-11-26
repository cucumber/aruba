# Aruba
module Aruba
  # Platforms
  module Platforms
    # Determine size of a file
    #
    # @param [String] path
    #   The path to file
    #
    # @return [Integer]
    #   Returns size if exists. Returns -1 if path does not exist
    class DetermineFileSize
      def call(path)
        return -1 unless File.file? path

        FileSize.new(
          File.size(path)
        )
      end
    end
  end
end
