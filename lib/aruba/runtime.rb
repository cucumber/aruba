require 'aruba/config'

module Aruba
  class Runtime
    attr_reader :config, :current_directory

    def initialize
      @config            = Aruba.config.make_copy
      @current_directory = ArubaPath.new(@config.working_directory)
    end
  end
end
