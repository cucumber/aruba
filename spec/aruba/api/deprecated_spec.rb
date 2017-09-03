require 'spec_helper'

RSpec.describe 'Deprecated API' do
  include_context 'uses aruba API'

  around do |example|
    Aruba.platform.with_environment do
      example.run
    end
  end

  before do
    allow(Aruba.platform).to receive(:deprecated)
  end

  describe "#assert_not_matching_output" do
    before(:each){ @aruba.run_simple("echo foo", false) }
    after(:each) { @aruba.all_commands.each(&:stop) }

    it "passes when the output doesn't match a regexp" do
      @aruba.assert_not_matching_output "bar", @aruba.all_output
    end
    it "fails when the output does match a regexp" do
      expect do
        @aruba.assert_not_matching_output "foo", @aruba.all_output
      end . to raise_error RSpec::Expectations::ExpectationNotMetError
    end
  end
end
