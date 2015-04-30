require 'spec_helper'

RSpec.describe 'Path Matchers' do
  include_context 'uses aruba API'

  def expand_path(*args)
    @aruba.expand_path(*args)
  end

  describe 'to_match_path_pattern' do
    context 'when pattern is string' do
      context 'when there is file which matches path pattern' do
        before :each do
          File.write(@file_path, '')
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
          File.write(@file_path, '')
        end

        it { expect(all_paths).to match_path_pattern(/test/) }
      end

      context 'when there is not file which matches path pattern' do
        it { expect(all_paths).not_to match_path_pattern(/test/) }
      end
    end
  end

  describe 'to_be_existing_path' do
    context 'when file' do
      context 'exists' do
        before :each do
          File.write(@file_path, '')
        end

        it { expect(@file_name).to be_existing_path }
      end

      context 'does not exist' do
        it { expect(@file_name).not_to be_existing_path }
      end
    end

    context 'when directory' do
      let(:name) { 'test.d' }
      let(:path) { File.join(@aruba.current_directory, name) }

      context 'exists' do
        before :each do
          FileUtils.mkdir_p path
        end

        it { expect(name).to be_existing_path }
      end

      context 'does not exist' do
        it { expect(name).not_to be_existing_path }
      end
    end
  end
end
