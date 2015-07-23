module Aruba
  module Platforms
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
