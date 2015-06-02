RSpec.shared_examples 'a basic configuration' do
  subject(:config) do
    Class.new(described_class) do
      option_accessor :use_test, contract: { Contracts::Bool => Contracts::Bool }, default: false
    end.new
  end

  it { expect(config).not_to be_nil }

  describe 'option?' do
    let(:name) { :use_test }

    context 'when valid option' do
      it { expect(name).to be_valid_option }
    end

    context 'when invalid_option' do
      let(:name) { :blub }
      it { expect(name).not_to be_valid_option }
    end
  end

  describe 'set_if_option' do
    let(:name) { :use_test }
    let(:value) { true }

    context 'when valid option' do
      before(:each) { config.set_if_option(name, value) }
      it { expect(name).to have_option_value true }
    end

    context 'when invalid_option' do
      let(:name) { :blub }

      it { expect { config.set_if_option(name, value) }.not_to raise_error }
    end
  end
end
