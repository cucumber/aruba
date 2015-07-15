require 'aruba/environments/basic_environment'

module Aruba
  module Environments
    class UnixEnvironment < BasicEnvironment
      def match?(*)
        Aruba::Platform.unix?
      end
    end
  end
end
