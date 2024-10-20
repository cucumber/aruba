# frozen_string_literal: true

module Aruba
  module Platforms
    # File System Status object
    #
    # This is a wrapper for File::Stat returning only a subset of information.
    class FilesystemStatus
      private

      attr_reader :status

      public

      def executable?
        status.executable?
      end

      def ctime
        status.ctime
      end

      def atime
        status.atime
      end

      def mtime
        status.mtime
      end

      def size
        status.size
      end

      def initialize(path)
        @status = File::Stat.new(path)
      end

      # Return permissions
      def mode
        format('%o', status.mode)[-4, 4].gsub(/^0*/, '')
      end

      # Return owner
      def owner
        status.uid
      end

      # Return owning group
      def group
        status.gid
      end

      # Convert status to hash
      #
      # @return [Hash]
      #   A hash of values
      def to_h
        {
          owner: owner,
          group: group,
          mode: mode,
          executable: executable?,
          ctime: ctime,
          atime: atime,
          mtime: mtime,
          size: size
        }
      end
    end
  end
end
