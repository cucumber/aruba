# frozen_string_literal: true

require "spec_helper"

describe Aruba::EventBus::NameResolver do
  let(:resolver) { described_class.new(default_name_space) }

  let(:default_name_space) { "Events" }
  let(:resolved_name) { resolver.transform(original_name) }

  before do
    stub_const("Events::MyEvent", Class.new)
  end

  describe "#transform" do
    context "when name is string" do
      context "when simple" do
        let(:original_name) { "Events::MyEvent" }

        it { expect(resolved_name).to eq Events::MyEvent }
      end

      context "when prefixed" do
        let(:original_name) { "::Events::MyEvent" }

        it { expect(resolved_name).to eq Events::MyEvent }
      end
    end

    context "when name is class" do
      let(:original_name) { Events::MyEvent }

      it { expect(resolved_name).to eq Events::MyEvent }
    end

    context "when name is symbol" do
      let(:original_name) { :my_event }

      it { expect(resolved_name).to eq Events::MyEvent }
    end

    context "when namespace ..." do
      before do
        stub_const("MyLib::Events::MyEvent", Class.new)
      end

      context "when is string" do
        let(:default_name_space) { "MyLib::Events" }
        let(:original_name) { :my_event }

        it { expect(resolved_name).to eq MyLib::Events::MyEvent }
      end

      context "when is module" do
        let(:default_name_space) { MyLib::Events }
        let(:original_name) { :my_event }

        it { expect(resolved_name).to eq MyLib::Events::MyEvent }
      end
    end

    context "when invalid" do
      let(:original_name) { 1 }

      it {
        expect { resolved_name }
          .to raise_error Aruba::EventNameResolveError, /Transforming "1"/
      }
    end
  end
end
