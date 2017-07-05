require 'ffi'

module Aruba
  class CurrentPlatform
    def is
      FFI::Platform.windows? ? :windows : :unix
    end
  end
end
