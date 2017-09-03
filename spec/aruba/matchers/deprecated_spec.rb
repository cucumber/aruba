require 'spec_helper'

RSpec.describe 'Deprecated matchers' do
  include_context 'uses aruba API'

  before do
    allow(Aruba.platform).to receive(:deprecated)
  end

  describe 'to_match_path_pattern' do
    context 'when pattern is string' do
      context 'when there is file which matches path pattern' do
        before :each do
          Aruba.platform.write_file(@file_path, '')
        end

        it { expect(all_paths).to match_path_pattern(expand_path(@file_name)) }
      end

      context 'when there is not file which matches path pattern' do
        it { expect(all_paths).not_to match_path_pattern('test') }
      end
    end

    context 'when pattern is regex' do
      context 'when there is file which matches path pattern' do
        before :each do
          Aruba.platform.write_file(@file_path, '')
        end

        it { expect(all_paths).to match_path_pattern(/test/) }
      end

      context 'when there is not file which matches path pattern' do
        it { expect(all_paths).not_to match_path_pattern(/test/) }
      end
    end
  end
end
