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
      def use_clean_gemset(gemset)
        run_simple(%{rvm gemset create "#{gemset}"}, true)
        if all_stdout =~ /'#{gemset}' gemset created \((.*)\)\./
          gem_home = Regexp.last_match[1]
          set_environment_variable('GEM_HOME', gem_home)
          set_environment_variable('GEM_PATH', gem_home)
          set_environment_variable('BUNDLE_PATH', gem_home)

          paths = (ENV['PATH'] || "").split(File::PATH_SEPARATOR)
          paths.unshift(File.join(gem_home, 'bin'))
          set_environment_variable('PATH', paths.uniq.join(File::PATH_SEPARATOR))

          run_simple("gem install bundler", true)
        else
          raise "I didn't understand rvm's output: #{all_stdout}"
        end
      end
    end
  end
end
