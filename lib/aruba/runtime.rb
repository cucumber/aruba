require 'aruba/config'
require 'aruba/environment'

module Aruba
  class Runtime
    attr_reader :config, :current_directory, :environment, :root_directory

    def initialize
      @config            = Aruba.config.make_copy
      @current_directory = ArubaPath.new(@config.working_directory)
      @root_directory    = ArubaPath.new(@config.root_directory)
      @environment       = Environment.new
    end

    # The path to the directory which contains fixtures
    # You might want to overwrite this method to place your data else where.
    #
    # @return [ArubaPath]
    #   The directory to where your fixtures are stored
    def fixtures_directory
      unless @fixtures_directory
        candidates = config.fixtures_directories.map { |dir| File.join(root_directory, dir) }
        @fixtures_directory = candidates.find { |d| Aruba::Platform.directory? d }

        fail "No existing fixtures directory found in #{candidates.map { |d| format('"%s"', d) }.join(', ')}. " unless @fixtures_directory
      end

      fail %(Fixtures directory "#{@fixtures_directory}" is not a directory) unless Aruba::Platform.directory?(@fixtures_directory)

      ArubaPath.new(@fixtures_directory)
    end
  end
end
