# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Aruba::Processes::DebugProcess do
  subject(:process) do
    described_class.new(command_line, exit_timeout, io_wait, working_directory)
  end

  include_context 'uses aruba API'

  let(:command_line) { 'true' }
  let(:exit_timeout) { 30 }
  let(:io_wait) { 1 }
  let(:working_directory) { @aruba.expand_path('.') }

  describe '#stop' do
    it 'makes the process stopped' do
      process.start
      process.stop
      expect(process).to be_stopped
    end
  end

  describe '#command' do
    let(:command_line) { "ruby -e 'warn \"yo\"'" }

    it 'returns the first item of the command line' do
      expect(process.command).to eq 'ruby'
    end
  end

  describe '#arguments' do
    let(:command_line) { "ruby -e 'warn \"yo\"'" }

    it 'handles arguments delimited with quotes' do
      expect(process.arguments).to eq ['-e', 'warn "yo"']
    end
  end
end
