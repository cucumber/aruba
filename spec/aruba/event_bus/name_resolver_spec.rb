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
    context "when name is symbol" do
      let(:original_name) { :my_event }

      it { expect(resolved_name).to eq Events::MyEvent }
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
