RSpec.shared_examples 'a basic configuration' do
  subject(:config) do
    Class.new(described_class) do
      option_accessor :use_test, :contract => { Contracts::Bool => Contracts::Bool }, :default => false
    end.new
  end

  it { expect(config).not_to be_nil }

  describe '.option_reader' do
    let(:config_klass) { Class.new(described_class) }

    subject(:config) { config_klass.new }

    before :each do
      config_klass.option_reader :new_opt, :contract => { Contracts::Num => Contracts::Num }, :default => 1
    end

    context 'when value is read' do
      it { expect(config.new_opt).to eq 1 }
    end

    context 'when one tries to write a value' do
      it { expect{ config.new_opt = 1}.to raise_error NoMethodError }
    end

    context 'when block is defined' do
      before :each do
        config_klass.option_reader :new_opt2, :contract => { Contracts::Num => Contracts::Num } do |c|
          c.new_opt.value + 1
        end
      end

      it { expect(config.new_opt2).to eq 2 }
    end

    context 'when block and default value is defined' do
      it do
        expect do
          config_klass.option_accessor :new_opt2, :contract => { Contracts::Num => Contracts::Num }, :default => 2 do |c|
            c.new_opt.value + 1
          end
        end.to raise_error ArgumentError, 'Either use block or default value'
      end
    end
  end

  describe '.option_accessor' do
    let(:config_klass) { Class.new(described_class) }

    subject(:config) { config_klass.new }

    before :each do
      config_klass.option_accessor :new_opt, :contract => { Contracts::Num => Contracts::Num }, :default => 1
    end

    context 'when default is used' do
      it { expect(config.new_opt).to eq 1 }
    end

    context 'when is modified' do
      before(:each) { config.new_opt = 2 }

      it { expect(config.new_opt).to eq 2 }
    end

    context 'when block is defined' do
      before :each do
        config_klass.option_accessor :new_opt2, :contract => { Contracts::Num => Contracts::Num } do |c|
          c.new_opt.value + 1
        end
      end

      it { expect(config.new_opt2).to eq 2 }
    end

    context 'when block and default value is defined' do
      it do
        expect do
          config_klass.option_accessor :new_opt2, :contract => { Contracts::Num => Contracts::Num }, :default => 2 do |c|
            c.new_opt1 + 1
          end
        end.to raise_error ArgumentError, 'Either use block or default value'
      end
    end
  end

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
