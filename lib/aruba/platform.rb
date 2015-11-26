require 'thread'
require 'aruba/platforms/unix_platform'
require 'aruba/platforms/windows_platform'

# Aruba
module Aruba
  PLATFORM_MUTEX = Mutex.new
end

# Aruba
module Aruba
  # Platform
  Platform = [Platforms::WindowsPlatform, Platforms::UnixPlatform].find(&:match?)
end

# Aruba
module Aruba
  PLATFORM_MUTEX.synchronize do
    @platform = Platform.new
  end

  class << self
    attr_reader :platform
  end
end
