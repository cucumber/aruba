require 'fileutils'
require 'securerandom'

RSpec.shared_context 'uses aruba API' do
  def random_string(options = {})
    options[:prefix].to_s + SecureRandom.hex + options[:suffix].to_s
  end

  def create_test_files(files, data = 'a')
    Array(files).each do |s|
      next if s.to_s[0] == '%'
      local_path = expand_path(s)

      FileUtils.mkdir_p File.dirname(local_path)
      File.open(local_path, 'w') { |f| f << data }
    end
  end

  before(:each) do
    klass = Class.new do
      include Aruba::Api

      def set_tag(tag_name, value)
        self.instance_variable_set "@#{tag_name}", value
      end
    end

    @aruba = klass.new

    @file_name = "test.txt"
    @file_size = 256
    @file_path = @aruba.expand_path(@file_name)
    @aruba.setup_aruba

    raise "We must work with relative paths, everything else is dangerous" if ?/ == @aruba.aruba.current_directory[0]
  end
end

RSpec.shared_context 'needs to expand paths' do
  def expand_path(*args)
    @aruba.expand_path(*args)
  end
end

RSpec.shared_context 'needs to run with environment' do
  def with_environment(*args, &block)
    @aruba.with_environment(*args, &block)
  end
end
