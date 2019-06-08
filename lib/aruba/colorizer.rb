# Aruba
module Aruba
  # Simple colorizer class. Only supports the color cyan
  class Colorizer
    class << self
      attr_accessor :coloring

      alias coloring? coloring
    end

    def cyan(string)
      if self.class.coloring?
        "\e[36m#{string}\e[0m"
      else
        string
      end
    end
  end
end
