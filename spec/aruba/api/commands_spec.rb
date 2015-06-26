require 'spec_helper'

RSpec.describe 'Commands' do
  include_context 'uses aruba API'

  describe "#get_process" do
    before(:each){ @aruba.run_simple 'true' }

    after(:each){ @aruba.stop_commands }

    context 'when existing process' do
      it { expect(@aruba.get_process('true')).not_to be nil }
    end

    context 'when non-existing process' do
      it { expect{ @aruba.get_process('false') }.to raise_error(ArgumentError, "No command named 'false' has been started") }
    end
  end

  describe "#run_simple" do
    after(:each){ @aruba.stop_commands }

    context 'when simple command' do
      it { expect { @aruba.run_simple "true" }.not_to raise_error }
    end

    context 'when long running command' do
      it { expect { @aruba.run_simple 'bash -c "sleep 7"' }.not_to raise_error }
    end
  end

  describe "#run" do
    context 'when interactive comand' do
      before(:each){ @aruba.run 'cat' }

      after(:each){ @aruba.stop_commands }

      context 'when input is given' do
        before :each do
          @aruba.type "Hello"
          @aruba.type ""
        end

        it { expect(@aruba.all_output).to eq  "Hello\n" }
      end

      context 'when input is closed' do
        before :each do
          @aruba.type "Hello"
          @aruba.close_input
        end

        it { expect(@aruba.all_output).to eq  "Hello\n" }
        it { expect(@aruba.type).to raise_error }
      end

      context 'when data is piped into it' do
        before :each do
          @aruba.write_file(@file_name, "Hello\nWorld!")
          @aruba.pipe_in_file(@file_name)
          @aruba.close_input
        end

        it { expect(@aruba.all_output).to eq  "Hello\nWorld!" }
      end
    end
  end
end
