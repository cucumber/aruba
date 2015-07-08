module Aruba
  # Create things to make aruba work
  module Creators
    # Normal File Creator
    # This class is not meant to be used directly by users.
    class ArubaFileCreator
      # Write File
      #
      # @param [String] path
      #   The path to write content to
      #
      # @param [Object] content
      #   The content of the file
      #
      # @param [TrueClass, FalseClass] check_presence (false)
      #   Check if file exist
      def write(path, content, check_presence = false)
        fail "Expected #{path} to be present" if check_presence && !Aruba::Platform.file?(path)

        Aruba::Platform.mkdir(File.dirname(path))

        if RUBY_VERSION < '1.9'
          File.open(path, 'w') { |f| f << content }
        else
          File.write(path, content)
        end

        self
      end
    end
  end
end
