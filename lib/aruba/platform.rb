require 'rbconfig'

module Aruba
  # All methods found here are not considered part of the public API of aruba.
  #
  # Those methods can be changed at any time in the feature or removed without
  # any further notice.
  module Platform
    def detect_ruby(cmd)
      if cmd =~ /^ruby\s/
        cmd.gsub(/^ruby\s/, "#{current_ruby} ")
      else
        cmd
      end
    end

    def current_ruby
      ::File.join(RbConfig::CONFIG['bindir'], RbConfig::CONFIG['ruby_install_name'])
    end

    def ensure_newline(str)
      str.chomp << "\n"
    end

    def require_matching_files(pattern, base)
      ::Dir.glob(::File.expand_path(pattern, base)).each { |f| require_relative f }
    end

    def mkdir(dir_name)
      dir_name = ::File.expand_path(dir_name)

      ::FileUtils.mkdir_p(dir_name) unless ::File.directory?(dir_name)
    end

    def rm(paths, options = {})
      paths = Array(paths).map { |p| ::File.expand_path(p) }

      FileUtils.rm_r(paths, options)
    end

    def chdir(dir_name, &block)
      dir_name = ::File.expand_path(dir_name)

      ::Dir.chdir(dir_name, &block)
    end

    module_function :detect_ruby, :current_ruby, :ensure_newline, :require_matching_files, :mkdir, :rm, :chdir
  end
end
