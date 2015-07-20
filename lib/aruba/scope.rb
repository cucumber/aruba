require 'rspec/expectations'
require 'aruba/api'
require 'thread'

module Aruba
  module Scope
    class LocalScope
      include RSpec::Matchers
      include Aruba::Api
    end
  end
end

module Aruba
  module Scope
    SCOPE_SEMAPHONE = Mutex.new

    def aruba_scope(&block)
      SCOPE_SEMAPHONE.synchronize do
        @scope ||= LocalScope.new
        @scope.instance_eval(&block) if block_given?
      end
    end
  end
end
