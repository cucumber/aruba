require 'aruba/aruba_path'

module Aruba
  module Contracts
    class AbsolutePath
      def self.valid?(value)
        ArubaPath.new(value).absolute?
      rescue
        false
      end
    end
  end
end
