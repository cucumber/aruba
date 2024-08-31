# frozen_string_literal: true

require 'aruba/platforms/unix_platform'
require 'aruba/platforms/windows_platform'

# Aruba
module Aruba
  PLATFORM_MUTEX = Mutex.new

  PLATFORM = [Platforms::WindowsPlatform, Platforms::UnixPlatform].find(&:match?)

  PLATFORM_MUTEX.synchronize do
    @platform = PLATFORM.new
  end

  class << self
    attr_reader :platform
  end
end
