require 'spec_helper'
require 'aruba/api'
require 'fileutils'

RSpec.describe Aruba::Api::Commands do
  include_context 'uses aruba API'

  describe '#run_command' do
    context 'when succesfully running a command' do
      before(:each) { @aruba.run_command 'cat' }
      after(:each) { @aruba.all_commands.each(&:stop) }

      it "respond to input" do
        @aruba.type "Hello"
        @aruba.type ""
        expect(@aruba.last_command_started).to have_output "Hello"
      end

      it "respond to close_input" do
        @aruba.type "Hello"
        @aruba.close_input
        expect(@aruba.last_command_started).to have_output "Hello"
      end

      it "pipes data" do
        @aruba.write_file(@file_name, "Hello\nWorld!")
        @aruba.pipe_in_file(@file_name)
        @aruba.close_input
        expect(@aruba.last_command_started).to have_output "Hello\nWorld!"
      end
    end

    context 'when mode is :in_process' do
      before do
        @aruba.aruba.config.command_launcher = :in_process
      end

      after do
        @aruba.aruba.config.command_launcher = :spawn
      end

      it 'raises an error' do
        expect { @aruba.run_command 'cat' }.to raise_error NotImplementedError
      end
    end
  end
end
