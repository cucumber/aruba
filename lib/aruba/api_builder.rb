require 'aruba/current_platform'

module Aruba
  class ApiBuilder
    def gen(klass, for_platforms)
      generic_klass = Class.new do
        protected

        attr_reader :current_platform

        public

        def initialize(current_platform:)
          @current_platform = current_platform
        end
      end

      generic_klass.send(:define_method, :call) do |*args|
        o = for_platforms[current_platform.is]

        raise PlatformNotSupportedError, "Current platform \"#{current_platform.is}\" is not supported" if o.nil?

        return o.call(*args) if o.respond_to? :call
        o.new.call(*args)
      end

      generic_klass
    end
  end

  API_BUILDER = ApiBuilder.new
end
