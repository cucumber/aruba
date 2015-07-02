require 'aruba/aruba_path'

module Aruba
  module Contracts
    class RelativePath
      def self.valid?(value)
        ArubaPath.new(value).relative?
      rescue
        false
      end
    end
  end
end
