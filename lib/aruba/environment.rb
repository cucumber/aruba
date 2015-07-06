module Aruba
  class Environment
    private

    attr_reader :env

    public

    def initialize
      @env = ENV.to_hash
    end

    def update(other_env)
      env.update other_env

      self
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
        env.to_hash
      else
        env.to_h
      end
    end
  end
end
