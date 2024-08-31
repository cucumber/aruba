# frozen_string_literal: true

require 'cucumber/core/event_bus'

module Aruba
  # Event bus
  #
  # Implements and in-process pub-sub events broadcaster allowing multiple observers
  # to subscribe to different events that fire as your tests are executed.
  #
  class EventBus < Cucumber::Core::EventBus
    def register(ids, handler_object = nil, &handler_proc)
      Array(ids).each do |event_id|
        on(event_id, handler_object, &handler_proc)
      end
    end

    def notify(event)
      broadcast(event)
    end
  end
end
