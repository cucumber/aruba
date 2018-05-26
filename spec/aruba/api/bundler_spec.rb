require 'spec_helper'
require 'aruba/api'

RSpec.describe Aruba::Api::Bundler do
  include_context 'uses aruba API'

  describe '#unset_bundler_env_vars' do
    it "sets up Aruba's environment to clear Bundler's variables" do
      @aruba.unset_bundler_env_vars

      expect(@aruba.aruba.environment['BUNDLE_PATH']).to be_nil
      expect(@aruba.aruba.environment['BUNDLE_GEMFILE']).to be_nil
    end
  end
end
