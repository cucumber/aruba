require 'rbconfig'

module Aruba
  module Platform
    def detect_ruby(cmd)
      if cmd =~ /^ruby\s/
        cmd.gsub(/^ruby\s/, "#{current_ruby} ")
      else
        cmd
      end
    end

    def current_ruby
      File.join(RbConfig::CONFIG['bindir'], RbConfig::CONFIG['ruby_install_name'])
    end

    def ensure_newline(str)
      str.chomp << "\n"
    end

    def require_matching_files(pattern)
      Dir.glob(File.expand_path(pattern)).each { |f| require_relative f }
    end

    module_function :detect_ruby, :current_ruby, :ensure_newline, :require_matching_files
  end
end
