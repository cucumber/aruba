require 'forwardable'

module Aruba
  module Platforms
    # File System Status object
    #
    # This is a wrapper for File::Stat returning only a subset of information.
    class FilesystemStatus
      METHODS = [
        :executable?,
        :ctime,
        :atime,
        :mtime,
        :size
      ].freeze

      extend Forwardable

      private

      attr_reader :status

      public

      if RUBY_VERSION >= '1.9.3'
        def_delegators :@status, *METHODS
      else
        def_delegators :@status, :executable?, :ctime, :atime, :mtime, :size
      end

      def initialize(path)
        @status = File::Stat.new(path)
      end

      # Return permissions
      def mode
        format("%o", status.mode)[-4,4].gsub(/^0*/, '')
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
          :owner      => owner,
          :group      => group,
          :mode       => mode,
          :executable => executable?,
          :ctime      => ctime,
          :atime      => atime,
          :mtime      => mtime,
          :size       => size
        }
      end
    end
  end
end
