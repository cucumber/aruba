require 'spec_helper'

RSpec.describe Aruba::Platforms::UnixCommandString do
  let(:command_string) { described_class.new(base_command, *arguments) }
  let(:arguments) { [] }

  describe '#to_a' do
    context 'with a command with a path' do
      let(:base_command) { '/foo/bar' }
      it { expect(command_string.to_a).to eq [base_command] }
    end

    context 'with a command with a path containing spaces' do
      let(:base_command) { '/foo bar/baz' }
      it { expect(command_string.to_a).to eq [base_command] }
    end

    context 'with a command and arguments' do
      let(:base_command) { '/foo/bar' }
      let(:arguments) { ['-w', 'baz quux'] }
      it { expect(command_string.to_a).to eq [base_command, *arguments] }
    end
  end

  describe '#to_s' do
    context 'with a command with a path' do
      let(:base_command) { '/foo/bar' }
      it { expect(command_string.to_s).to eq base_command }
    end

    context 'with a command with a path containing spaces' do
      let(:base_command) { '/foo bar/baz' }
      it { expect(command_string.to_s).to eq base_command }
    end

    context 'with a command and arguments' do
      let(:base_command) { '/foo/bar' }
      let(:arguments) { ['-w', 'baz quux'] }
      it { expect(command_string.to_s).to eq base_command }
    end
  end
end
