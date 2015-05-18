RSpec.shared_context 'uses aruba API' do
  def random_string(options = {})
    options[:prefix].to_s + SecureRandom.hex + options[:suffix].to_s
  end

  before(:each) do
    klass = Class.new do
      include Aruba::Api

      def set_tag(tag_name, value)
        self.instance_variable_set "@#{tag_name}", value
      end

      def announce_or_puts(*args)
        p caller[0..2]
      end
    end

    @aruba = klass.new

    @file_name = "test.txt"
    @file_size = 256
    @file_path = File.join(@aruba.current_directory, @file_name)

    (@aruba.dirs.length - 1).times do |depth| #Ensure all parent dirs exists
      dir = File.join(*@aruba.dirs[0..depth])
      Dir.mkdir(dir) unless File.exist?(dir)
    end
    raise "We must work with relative paths, everything else is dangerous" if ?/ == @aruba.current_directory[0]
    FileUtils.rm_rf(@aruba.current_directory)
    Dir.mkdir(@aruba.current_directory)
  end
end
