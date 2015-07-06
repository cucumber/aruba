require 'aruba/config'
require 'aruba/environment'

module Aruba
  class Runtime
    attr_reader :config, :current_directory, :environment

    def initialize
      @config            = Aruba.config.make_copy
      @current_directory = ArubaPath.new(@config.working_directory)
      @environment       = Environment.new
    end
  end
end
