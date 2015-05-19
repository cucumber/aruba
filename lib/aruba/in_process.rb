require 'aruba/processes/in_process'

module Aruba
  class InProcess < Aruba::Processes::InProcess
    def initialize(*args)
      warn('The use of "Aruba::InProcess" is deprecated. Use "Aruba::Processes::InProcess" instead.')

      super
    end
  end
end
