require 'aruba/event_bus/name_resolver'
require 'aruba/errors'

module Aruba
  # Event bus
  #
  # Implements and in-process pub-sub events broadcaster allowing multiple observers
  # to subscribe to different events that fire as your tests are executed.
  #
  class EventBus
    # Create EventBus
    #
    # @param [#transform] resolver
    #   A resolver which transforms Symbol, String, Class into an event Class.
    def initialize(resolver)
      @resolver = resolver
      @handlers = Hash.new { |h, k| h[k] = [] }
    end

    # Register for an event
    #
    # @param [String, Symbol, Class, Array] event_ids
    #   If Array, register multiple events witht the same handler. If String,
    #   Symbol, Class register handler for given event.
    #
    # @param [#call] handler_object
    #   The handler object, needs to have method `#call`. Either
    #   `handler_object` or `block` can be defined. The handler object gets the
    #   event passed to `#call`.
    #
    # @yield
    #   Handler block which gets the event passed as parameter.
    def register(event_ids, handler_object = nil, &handler_proc)
      handler = handler_proc || handler_object

      fail ArgumentError, 'Please pass either an object#call or a handler block' if handler.nil? || !handler.respond_to?(:call)

      Array(event_ids).flatten.each do |id|
        @handlers[
          @resolver.transform(id).to_s
        ] << handler
      end

      nil
    end

    # Broadcast an event
    #
    # @param [Object] event
    #   An object of registered event class. This object is passed to the event
    #   handler.
    #
    def notify(event)
      fail NoEventError, 'Please pass an event object, not a class' if event.is_a?(Class)

      @handlers[event.class.to_s].each { |handler| handler.call(event) }
    end
  end
end
