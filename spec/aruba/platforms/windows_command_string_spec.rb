require 'spec_helper'

RSpec.describe Aruba::Platforms::WindowsCommandString do
  let(:command_string) { described_class.new(base_command) }
  let(:cmd_path) { 'C:\Some Path\cmd.exe' }

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
      it { expect(command_string.to_a).to eq [cmd_path, '/c', base_command] }
    end
  end
end
