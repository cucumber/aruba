require 'aruba/api/environment'
require 'aruba/api/command'

# Aruba
module Aruba
  # Api
  module Api
    # RVM
    #
    # @deprecated
    module Rvm
      # Use a clean rvm gemset
      #
      # Please make sure that you've got [rvm](http://rvm.io/) installed.
      #
      # @param [String] gemset
      #   The name of the gemset to be used
      def use_clean_gemset(gemset_name)
        new_gem_home = current_gemset_home(gemset_name)
        new_bin_path = File.join(new_gem_home, 'bin')

        original_gem_home = current_gem_home
        original_bin_path = File.join(original_gem_home, 'bin')

        set_environment_variable('GEM_HOME', new_gem_home)
        set_environment_variable('BUNDLE_PATH', new_gem_home)
        set_environment_variable('GEM_PATH', replace_paths(ENV['GEM_PATH'], original_gem_home, new_gem_home))
        set_environment_variable('PATH', replace_paths(ENV['PATH'], original_bin_path, new_bin_path))

        delete_environment_variable('BUNDLE_BIN_PATH')
        delete_environment_variable('BUNDLE_GEMFILE')
        delete_environment_variable('RUBYOPT')

        # if not enough, consider 'gem server' and use '--source' in your '~/.gemrc'
        default_bundler_install_timeout = 30
        rvm_run("gem install bundler", :timeout => default_bundler_install_timeout)
      end

      # Unset variables used by bundler
      def unset_bundler_env_vars
        %w[RUBYOPT BUNDLE_PATH BUNDLE_BIN_PATH BUNDLE_GEMFILE].each do |key|
          set_environment_variable(key, nil)
        end
      end

      private

      def current_gemset_home(gemset_name)
        output = rvm_capture(%{rvm gemset create "#{gemset_name}"}).chomp

        recognized_ouputs = [
          /- #gemset created (.*@[^\/]+)$/,
          /'[^']+' gemset created \((.*)\)\./
        ]

        recognized_ouputs.each do |format|
          gem_home = output[format, 1]
          return gem_home if gem_home
        end

        raise "I didn't understand rvm's output: #{output}"
      end

      def current_gem_home
        rvm_capture('rvm gemset gemdir').chomp
      end

      def modify_path_string(str)
        paths = (str || "").split(File::PATH_SEPARATOR)
        yield(paths).uniq.join(File::PATH_SEPARATOR)
      end

      def replace_paths(str, old, new)
        modify_path_string(str) do |paths|
          paths.delete(old)
          [new] + paths
        end
      end

      def rvm_capture(cmd)
        rvm_run(cmd)
        last_command_started.stdout.dup
      end

      def rvm_run(cmd, options = {})
        opts = [true, options[:timeout]].compact
        run_simple(cmd, *opts)
      end
    end
  end
end
