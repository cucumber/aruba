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

    module_function :detect_ruby, :current_ruby, :ensure_newline
  end
end
