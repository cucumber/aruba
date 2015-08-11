require 'thor'
require 'aruba/console'

module Aruba
  class Cli < Thor
    desc 'console', "Start aruba's console"
    def console
      Aruba::Console.new.start
    end
  end
end
