module Aruba
  class ArubaCommand < SimpleDelegator
    attr_reader :event_queue
    private :event_queue

    def initialize(obj, event_queue)
      @event_queue = event_queue

      super(obj)
    end

    def stop(*)
      event_queue.notify :command_stopped, self.commandline

      super

      event_queue.notify :command_stdout, self.stdout
      event_queue.notify :command_stderr, self.stderr
    end

    def terminate(*)
      event_queue.notify :command_stopped, self.commandline

      super

      event_queue.notify :command_stdout, self.stdout
      event_queue.notify :command_stderr, self.stderr
    end

    def start
      event_queue.notify :command_started, self.commandline
      super
    end
    alias_method :run!, :start
  end
end
