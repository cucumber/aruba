require 'aruba/processes/spawn_process'
require 'aruba/platform'

Aruba.platform.deprecated('The use of "Aruba::SpawnProcess" is deprecated. Use "Aruba::Processes::SpawnProcess" instead.')

module Aruba
  class SpawnProcess < Aruba::Processes::SpawnProcess
    def initialize(*args)
      Aruba.platform.deprecated('The use of "Aruba::SpawnProcess" is deprecated. Use "Aruba::Processes::SpawnProcess" instead.')

      super
    end
  end
end
