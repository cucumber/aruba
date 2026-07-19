# frozen_string_literal: true

require 'fileutils'
require 'securerandom'

RSpec.shared_context 'uses aruba API' do
  def random_string(prefix: nil, suffix: nil)
    prefix.to_s + SecureRandom.hex + suffix.to_s
  end

  def create_test_files(files, data = 'a')
    Array(files).each do |s|
      next if s.to_s[0] == '%'

      local_path = expand_path(s)

      FileUtils.mkdir_p File.dirname(local_path)
      File.open(local_path, 'w') { |f| f << data }
    end
  end

  before do
    @file_name = 'test.txt'
    @file_size = 256
    @file_path = expand_path(@file_name)

    if aruba.current_directory[0] == '/'
      raise 'We must work with relative paths, everything else is dangerous'
    end
  end
end
