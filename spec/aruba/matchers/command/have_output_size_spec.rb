require "spec_helper"

RSpec.describe "Output Matchers" do
  describe "#to_have_output_size" do
    context "when actual is a string" do
      let(:obj) { "string" }

      it "matches when the string is the given size" do
        expect(obj).to have_output_size 6
      end

      it "does not match when the string does not have the given size" do
        expect(obj).not_to have_output_size 5
      end
    end
  end
end
