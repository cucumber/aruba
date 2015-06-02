require 'aruba/processes/spawn_process'

module Aruba
  class SpawnProcess < Aruba::Processes::SpawnProcess
    def initialize(*args)
      warn('The use of "Aruba::SpawnProcess" is deprecated. Use "Aruba::Processes::SpawnProcess" instead.')

      super
    end
  end
end
