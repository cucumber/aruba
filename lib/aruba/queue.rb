module Aruba
  class Queue
    def initialize
      @queues = Hash.new { |h, k| h[k] ||= [] }
    end

    def register(event:, listener:)
      @queues[event] << listener
    end

    def event(event:, message:)
      @queues[event].each { |l| l.inform_about event, message }
    end
  end
end
