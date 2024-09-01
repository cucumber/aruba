# frozen_string_literal: true

require 'spec_helper'
require 'aruba/platforms/unix_platform'

RSpec.describe Aruba::Platforms::UnixPlatform do
  include_context 'uses aruba API'

  describe '.match?' do
    it 'works even when ruby is launched with --disable-gems and --disable-rubyopt' do
      aruba_lib = File.expand_path('../../../lib', __dir__)
      run_command_and_stop(
        "ruby --disable-rubyopt --disable-gems -I#{aruba_lib} " \
        "-e 'require \"aruba/platforms/unix_platform\"; " \
        "Aruba::Platforms::UnixPlatform.match?;'"
      )
      expect(last_command_started).to be_successfully_executed
    end
  end
end
