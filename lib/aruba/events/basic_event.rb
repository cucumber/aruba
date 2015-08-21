module Aruba
  module Events
    class BasicEvent
      attr_reader :entity

      def initialize(entity)
        @entity = entity
      end
    end
  end
end
