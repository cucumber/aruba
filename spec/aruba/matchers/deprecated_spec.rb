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

  describe "to have_same_file_content_like" do
    let(:file_name) { @file_name }
    let(:file_path) { @file_path }

    let(:reference_file) { 'fixture' }

    before :each do
      @aruba.write_file(@file_name, "foo bar baz")
      @aruba.write_file(reference_file, reference_file_content)
    end

    context 'when files are the same' do
      let(:reference_file_content) { 'foo bar baz' }

      context 'and this is expected' do
        it { expect(file_name).to have_same_file_content_like reference_file }
      end

      context 'and this is not expected' do
        it do
          expect { expect(file_name).not_to have_same_file_content_like reference_file }.to raise_error RSpec::Expectations::ExpectationNotMetError
        end
      end
    end

    context 'when files are not the same' do
      let(:reference_file_content) { 'bar' }

      context 'and this is expected' do
        it { expect(file_name).not_to have_same_file_content_like reference_file }
      end

      context 'and this is not expected' do
        it do
          expect { expect(file_name).to have_same_file_content_like reference_file }.to raise_error RSpec::Expectations::ExpectationNotMetError
        end
      end
    end
  end

  describe "include a_file_with_same_content_like" do
    let(:reference_file) { 'fixture' }
    let(:reference_file_content) { 'foo bar baz' }
    let(:file_with_same_content) { 'file_a.txt' }
    let(:file_with_different_content) { 'file_b.txt' }

    before :each do
      @aruba.write_file(file_with_same_content, reference_file_content)
      @aruba.write_file(reference_file, reference_file_content)
      @aruba.write_file(file_with_different_content, 'Some different content here...')
    end

    context 'when the array of files includes a file with the same content' do
      let(:files) { [file_with_different_content, file_with_same_content] }

      context 'and this is expected' do
        it { expect(files).to include a_file_with_same_content_like reference_file }
      end

      context 'and this is not expected' do
        it do
          expect { expect(files).not_to include a_file_with_same_content_like reference_file }.to raise_error RSpec::Expectations::ExpectationNotMetError
        end
      end
    end

    context 'when the array of files does not include a file with the same content' do
      let(:files) { [file_with_different_content] }

      context 'and this is expected' do
        it { expect(files).not_to include a_file_with_same_content_like reference_file }
      end

      context 'and this is not expected' do
        it do
          expect { expect(files).to include a_file_with_same_content_like reference_file }.to raise_error RSpec::Expectations::ExpectationNotMetError
        end
      end
    end
  end
end
