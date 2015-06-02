module Aruba
  class EventQueue
    def initialize
      @queues = Hash.new { |h, k| h[k] = [] }
    end

    def register(event, listener)
      fail ArgumentError, 'A valid listener needs to implement "#notify' unless listener.respond_to? :notify

      @queues[event.to_sym] << listener

      self
    end

    def notify(event, message)
      @queues[event].each { |l| l.notify Event.new(event, message) }
    end
  end
end
