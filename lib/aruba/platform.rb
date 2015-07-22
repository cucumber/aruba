require 'thread'
require 'aruba/platforms/unix_platform'
require 'aruba/platforms/windows_platform'

module Aruba
  PLATFORM_MUTEX = Mutex.new
end

module Aruba
  class Platform < SimpleDelegator
    def initialize
      @platforms = []
      @platforms << Aruba::Platforms::WindowsPlatform
      @platforms << Aruba::Platforms::UnixPlatform

      super @platforms.find(&:match?).new
    end
  end
end

module Aruba
  PLATFORM_MUTEX.synchronize do
    @platform = Platform.new
  end

  class << self
    attr_reader :platform
  end
end
