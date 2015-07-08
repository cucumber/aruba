module Aruba
  class Environment
    private

    attr_reader :env

    public

    def initialize
      @env = ENV.to_hash
    end

    def update(other_env, &block)
      if RUBY_VERSION < '1.9'
        # rubocop:disable Style/EachWithObject
        other_env = other_env.inject({}) { |a, (k, v)| a[k] = v.to_s; a }
        # rubocop:enable Style/EachWithObject
      else
        other_env = other_env.each_with_object({}) { |(k, v), a| a[k] = v.to_s }
      end

      env.update(other_env, &block)

      self
    end
    alias_method :merge, :update

    def fetch(name, default)
      env.fetch name.to_s, default
    end

    def key?(name)
      env.key? name.to_s
    end

    def [](name)
      env[name.to_s]
    end

    def []=(name, value)
      env[name.to_s] = value.to_s

      self
    end

    def append(name, value)
      name = name.to_s
      env[name] = env[name].to_s + value.to_s

      self
    end

    def prepend(name, value)
      name = name.to_s
      env[name] = value.to_s + env[name].to_s

      self
    end

    def to_h
      if RUBY_VERSION < '2.0'
        env.to_hash.dup
      else
        env.to_h.dup
      end
    end

    def clear
      env.clear
    end
  end
end
