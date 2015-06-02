module Aruba
  class Runtime
    attr_reader :config, :command_monitor

    def initialize
      @config = Aruba.config.deep_dup
      @command_monitor = Aruba::CommandMonitor.new
    end
  end
end
