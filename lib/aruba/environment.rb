require 'aruba/environments/unix_environment'
require 'aruba/environments/windows_environment'

module Aruba
  class Environment < SimpleDelegator
    def initialize
      environments = []
      environments << Aruba::Environments::WindowsEnvironment.new
      environments << Aruba::Environments::UnixEnvironment.new

      super environments.find(&:match?)
    end
  end
end
