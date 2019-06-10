require 'spec_helper'
require 'aruba/api'

RSpec.describe Aruba::Api::Commands do
  include_context 'uses aruba API'

  describe '#run_command' do
    before(:each){ @aruba.run_command 'cat' }
    after(:each) { @aruba.all_commands.each(&:stop) }

    it "responds to input" do
      @aruba.type "Hello"
      @aruba.type ""
      expect(@aruba.last_command_started).to have_output "Hello"
    end

    it "responds to close_input" do
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
end
