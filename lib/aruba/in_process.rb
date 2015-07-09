require 'aruba/processes/in_process'
require 'aruba/platform'

module Aruba
  class InProcess < Aruba::Processes::InProcess
    def initialize(*args)
      Aruba::Platform.deprecated('The use of "Aruba::InProcess" is deprecated. Use "Aruba::Processes::InProcess" instead.')

      super
    end
  end
end
