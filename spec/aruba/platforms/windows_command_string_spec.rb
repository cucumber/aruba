require 'spec_helper'

RSpec.describe Aruba::Platforms::WindowsCommandString do
  let(:command_string) { described_class.new(base_command, *arguments) }
  let(:cmd_path) { 'C:\Some Path\cmd.exe' }
  let(:arguments) { [] }

  before do
    allow(Aruba.platform).to receive(:which).with('cmd.exe').and_return(cmd_path)
  end

  describe '#to_a' do
    context 'with a command with a path' do
      let(:base_command) { 'C:\Foo\Bar' }
      it { expect(command_string.to_a).to eq [cmd_path, '/c', base_command] }
    end

    context 'with a command with a path containing spaces' do
      let(:base_command) { 'C:\Foo Bar\Baz' }
      it { expect(command_string.to_a).to eq [cmd_path, '/c', 'C:\Foo""" """Bar\Baz'] }
    end

    context 'with a command and arguments' do
      let(:base_command) { 'C:\Foo\Bar' }
      let(:arguments) { ['-w', 'baz quux'] }
      it { expect(command_string.to_a).to eq [cmd_path, '/c', "#{base_command} -w \"baz quux\""] }
    end
  end

  describe '#to_s' do
    context 'with a command with a path' do
      let(:base_command) { 'C:\Foo\Bar' }
      it { expect(command_string.to_s).to eq base_command }
    end

    context 'with a command with a path containing spaces' do
      let(:base_command) { 'C:\Foo Bar\Baz' }
      it { expect(command_string.to_s).to eq base_command }
    end

    context 'with a command and arguments' do
      let(:base_command) { 'C:\Foo\Bar' }
      let(:arguments) { ['-w', 'baz quux'] }
      it { expect(command_string.to_s).to eq base_command }
    end
  end
end
