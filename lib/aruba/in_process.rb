require 'aruba/processes/in_process'
require 'aruba/platform'

Aruba.platform.deprecated('The use of "Aruba::InProcess" is deprecated. Use "Aruba::Processes::InProcess" instead.')

# Aruba
module Aruba
  # @deprecated
  class InProcess < Aruba::Processes::InProcess
    def initialize(*args)
      Aruba.platform.deprecated('The use of "Aruba::InProcess" is deprecated. Use "Aruba::Processes::InProcess" instead.')

      super
    end
  end
end
