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

    def deprecated(msg)
      warn(format('%s. Called by %s', msg, caller[1]))
    end

    def current_ruby
      ::File.join(RbConfig::CONFIG['bindir'], RbConfig::CONFIG['ruby_install_name'])
    end

    def ensure_newline(str)
      str.chomp << "\n"
    end

    def require_matching_files(pattern, base)
      if RUBY_VERSION < '1.9.'
        ::Dir.glob(::File.expand_path(pattern, base)).each { |f| require File.join(File.dirname(f), File.basename(f, '.rb')) }
      else
        ::Dir.glob(::File.expand_path(pattern, base)).each { |f| require_relative f }
      end
    end

    # Create directory and subdirectories
    def mkdir(dir_name)
      dir_name = ::File.expand_path(dir_name)

      ::FileUtils.mkdir_p(dir_name) unless ::File.directory?(dir_name)
    end

    # Remove file, directory + sub-directories
    def rm(paths, options = {})
      paths = Array(paths).map { |p| ::File.expand_path(p) }

      FileUtils.rm_r(paths, options)
    end

    # Change to directory
    def chdir(dir_name, &block)
      dir_name = ::File.expand_path(dir_name)

      ::Dir.chdir(dir_name, &block)
    end

    # Touch file, directory
    def touch(args, options)
      FileUtils.touch(args, options)
    end

    # Copy file/directory
    def cp(args, options)
      FileUtils.cp_r(args, options)
    end

    # Change mode of file/directory
    def chmod(mode, args, options)
      FileUtils.chmod_R(mode, args, options)
    end

    # Exists and is file
    def file?(f)
      File.file? f
    end

    # Exists and is directory
    def directory?(f)
      File.directory? f
    end

    # Path Exists
    def exist?(f)
      File.exist? f
    end

    # Expand path
    def expand_path(path, base)
      File.expand_path(path, base)
    end

    # Write to file
    def write_file(path, content)
      if RUBY_VERSION < '1.9'
        File.open(path, 'wb') do |f|
          f.print content
        end
      else
        File.write(path, content)
      end
    end

    module_function :detect_ruby, \
      :current_ruby, \
      :ensure_newline, \
      :require_matching_files, \
      :mkdir, \
      :rm, \
      :chdir, \
      :deprecated, \
      :touch, \
      :cp, \
      :chmod, \
      :file?, \
      :directory?, \
      :exist?, \
      :expand_path, \
      :write_file
  end
end
