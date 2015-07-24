module Aruba
  module Platforms
    class LocalEnvironment
      def call(env, &block)
        old_env = ENV.to_hash.dup
        ENV.update env

        block.call if block_given?
      ensure
        ENV.clear
        ENV.update old_env
      end
    end
  end
end
