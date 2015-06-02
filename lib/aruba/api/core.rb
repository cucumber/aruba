module Aruba
  module Api
    module Core
      def aruba
        @_aruba_runtime ||= Runtime.new
      end
    end
  end
end
