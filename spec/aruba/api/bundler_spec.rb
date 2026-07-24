# frozen_string_literal: true

require 'spec_helper'
require 'aruba/api'

RSpec.describe Aruba::Api::Bundler, type: :aruba do
  describe '#unset_bundler_env_vars' do
    it "sets up Aruba's environment to clear Bundler's variables" do
      unset_bundler_env_vars

      expect(aruba.environment['BUNDLE_PATH']).to be_nil
      expect(aruba.environment['BUNDLE_GEMFILE']).to be_nil
    end
  end
end
