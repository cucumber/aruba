module Aruba
  module Api
    module Core
      # Aruba Runtime
      def aruba
        @_aruba_runtime ||= Runtime.new
      end

      # Execute block in current directory
      #
      # @yield
      #   The block which should be run in current directory
      def in_current_directory(&block)
        _mkdir(current_directory)
        Dir.chdir(current_directory, &block)
      end

      # @deprecated
      # @private
      def in_current_dir(*args, &block)
        warn('The use of "in_current_dir" is deprecated. Use "in_current_directory" instead')
        in_current_directory(*args, &block)
      end

      # Clean the current directory
      def clean_current_directory
        _rm_rf(current_directory)
        _mkdir(current_directory)
      end

      # @deprecated
      # @private
      def clean_current_dir(*args, &block)
        warn('The use of "clean_current_dir" is deprecated. Use "clean_current_directory" instead')
        clean_current_directory(*args, &block)
      end

      # Get access to current dir
      #
      # @return
      #   Current directory
      def current_directory
        File.join(*dirs)
      end

      # @deprecated
      # @private
      def current_dir(*args, &block)
        warn('The use of "current_dir" is deprecated. Use "current_directory" instead')
        current_directory(*args, &block)
      end

      # Switch to directory
      #
      # @param [String] dir
      #   The directory
      def cd(dir)
        dirs << dir
        raise "#{current_directory} is not a directory." unless File.directory?(current_directory)
      end

      # The path to the directory which should contain all your test data
      # You might want to overwrite this method to place your data else where.
      #
      # @return [Array]
      #   The directory path: Each subdirectory is a member of an array
      def dirs
        @dirs ||= Aruba.config.current_directory
      end
    end
  end
end
