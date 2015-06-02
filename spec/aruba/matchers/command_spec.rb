require 'spec_helper'

RSpec.describe 'Command Matchers' do
  include_context 'uses aruba API'

  def expand_path(*args)
    @aruba.expand_path(*args)
  end

  def announcer(*args)
    @aruba.send(:announcer, *args)
  end

  describe '#to_have_exit_status' do
    let(:cmd) { 'true' }

    before(:each) { run(cmd) }

    context 'when has exit 0' do
      it { expect(last_command).to have_exit_status 0 }
    end

    context 'when has exit 0' do
      let(:cmd) { 'false' }
      it { expect(last_command).not_to have_exit_status 0 }
    end
  end

  describe '#to_be_successfully_executed_' do
    let(:cmd) { 'true' }

    before(:each) { run(cmd) }

    context 'when has exit 0' do
      it { expect(last_command).to be_successfully_executed }
    end

    context 'when has exit 0' do
      let(:cmd) { 'false' }
      it { expect(last_command).not_to be_successfully_executed }
    end
  end
end
