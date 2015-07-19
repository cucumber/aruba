module Aruba
  module Platform
    class DetermineFileSize
      def use(path)
        return -1 unless File.file? path

        FileSize.new(
          File.size(path)
        )
      end
    end
  end
end
