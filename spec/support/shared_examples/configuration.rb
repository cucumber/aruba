# frozen_string_literal: true

RSpec.shared_examples "a basic configuration" do
  subject(:config) do
    Class.new(described_class) do
      option_accessor :use_test, type: Contracts::Bool,
                                 default: false
    end.new
  end

  it { expect(config).not_to be_nil }

  describe ".option_reader" do
    subject(:config) { config_klass.new }

    let(:config_klass) { Class.new(described_class) }

    before do
      config_klass.option_reader :new_opt, type: Contracts::Num,
                                           default: 1
    end

    context "when value is read" do
      it { expect(config.new_opt).to eq 1 }
    end

    context "when one tries to write a value" do
      it { expect { config.new_opt = 1 }.to raise_error NoMethodError }
    end

    context "when block is defined" do
      before do
        config_klass.option_reader(
          :new_opt2,
          type: Contracts::Num
        ) { |c| c.new_opt.value + 1 }
      end

      it "uses the block to set the value" do
        expect(config.new_opt2).to eq 2
      end
    end

    context "when block and default value is defined" do
      it "complains that only one or the other can be specified" do
        expect do
          config_klass
            .option_accessor(:new_opt2, type: Contracts::Num,
                                        default: 2) { |c| c.new_opt.value + 1 }
        end.to raise_error ArgumentError, "Either use block or default value"
      end
    end
  end

  describe ".option_accessor" do
    subject(:config) { config_klass.new }

    let(:config_klass) { Class.new(described_class) }

    before do
      config_klass.option_accessor :new_opt, type: Contracts::Num,
                                             default: 1
    end

    context "when default is used" do
      it { expect(config.new_opt).to eq 1 }
    end

    context "when is modified" do
      before { config.new_opt = 2 }

      it { expect(config.new_opt).to eq 2 }
    end

    context "when block is defined" do
      before do
        config_klass.option_accessor(
          :new_opt2, type: Contracts::Num
        ) do |c|
          c.new_opt.value + 1
        end
      end

      it "uses the block to set the default value" do
        expect(config.new_opt2).to eq 2
      end
    end

    context "when block and default value is defined" do
      it "complains that only one or the other can be specified" do
        expect do
          config_klass.option_accessor(:new_opt2,
                                       type: Contracts::Num,
                                       default: 2) { |c| c.new_opt1 + 1 }
        end.to raise_error ArgumentError, "Either use block or default value"
      end
    end
  end

  describe "option?" do
    let(:name) { :use_test }

    it "returns true when passed a valid option name" do
      expect(config.option?(:use_test)).to be_truthy
    end

    it "returns false when passed an invalid option name" do
      expect(config.option?(:blub)).to be_falsy
    end
  end

  describe "set_if_option" do
    let(:name) { :use_test }
    let(:value) { true }

    it "sets the option to the given value if a valid option name is passed" do
      expect { config.set_if_option(:use_test, true) }
        .to change(config, :use_test).from(false).to(true)
    end

    it "raises no error if an invalid option name is passed" do
      expect { config.set_if_option(:blub, true) }.not_to raise_error
    end
  end
end
