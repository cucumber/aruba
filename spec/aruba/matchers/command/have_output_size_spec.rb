# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Output Matchers' do
  describe '#to_have_output_size' do
    context 'when actual is a string' do
      let(:obj) { 'string' }

      before do
        allow(Aruba.platform).to receive(:deprecated)
      end

      it 'matches when the string is the given size' do
        expect(obj).to have_output_size 6
      end

      it 'does not match when the string does not have the given size' do
        expect(obj).not_to have_output_size 5
      end

      it 'emits a deprecation warning' do
        aggregate_failures do
          expect(obj).to have_output_size 6
          expect(Aruba.platform).to have_received(:deprecated)
        end
      end
    end

    context 'when actual is a command' do
      let(:cmd) { "echo #{output}" }
      let(:output) { 'hello world' }

      before { run_command(cmd) }

      it 'matches directly on the command itself' do
        expect(last_command_started).to have_output_size "#{output}\n".length
      end

      it 'does not match if output size is different' do
        expect(last_command_started).not_to have_output_size "#{output}\n".length + 1
      end
    end
  end
end
