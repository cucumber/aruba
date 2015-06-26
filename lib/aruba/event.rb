module Aruba
  class Event
    attr_reader :name, :message

    def initialize(name, message)
      @name    = name
      @message = message
    end
  end
end
