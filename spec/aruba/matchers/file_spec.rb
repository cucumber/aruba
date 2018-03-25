require 'spec_helper'
require 'aruba/matchers/file'

RSpec.describe 'File Matchers' do
  include_context 'uses aruba API'
  include_context 'needs to expand paths'

  describe 'to_be_an_existing_file' do
    let(:name) { @file_name }

    context 'when file exists' do
      before(:each) { create_test_files(name) }

      it { expect(name).to be_an_existing_file }
    end

    context 'when file does not exist' do
      it { expect(name).not_to be_an_existing_file }
    end

    context 'when contains ~' do
      let(:name) { File.join('~', random_string) }

      before(:each) do
        @aruba.with_environment 'HOME' => expand_path('.') do
          create_test_files(name)
        end
      end

      it do
        @aruba.with_environment 'HOME' => expand_path('.') do
          expect(name).to be_an_existing_file
        end
      end
    end
  end

  describe 'to_have_file_content' do
    context 'when file exists' do
      before :each do
        Aruba.platform.write_file(@file_path, 'aba')
      end

      context 'and file content is exactly equal string ' do
        it { expect(@file_name).to have_file_content('aba') }
      end

      context 'and file content contains string' do
        it { expect(@file_name).to have_file_content(/b/) }
      end

      context 'and file content is not exactly equal string' do
        it { expect(@file_name).not_to have_file_content('c') }
      end

      context 'and file content not contains string' do
        it { expect(@file_name).not_to have_file_content(/c/) }
      end

      context 'when other matchers is given which matches a string start with "a"' do
        it { expect(@file_name).to have_file_content(a_string_starting_with('a')) }
      end
    end

    context 'when file does not exist' do
      it { expect(@file_name).not_to have_file_content('a') }
    end

    describe "description" do
      context "when string" do
        it { expect(have_file_content("a").description).to eq('have file content: "a"') }
      end

      context "when regexp" do
        it { expect(have_file_content(/a/).description).to eq('have file content: /a/') }
      end

      context "when matcher" do
        it { expect(have_file_content(a_string_starting_with("a")).description).to eq('have file content: a string starting with "a"') }
      end
    end

    describe 'failure messages' do
      def fail_with(message)
        raise_error(RSpec::Expectations::ExpectationNotMetError, message)
      end

      example 'for a string' do
        expect do
          expect(@file_name).to have_file_content("z")
        end.to fail_with('expected "test.txt" to have file content: "z"')
      end

      example 'for a string' do
        expect do
          expect(@file_name).to have_file_content(/z/)
        end.to fail_with('expected "test.txt" to have file content: /z/')
      end

      example 'for a matcher' do
        expect do
          expect(@file_name).to have_file_content(a_string_starting_with("z"))
        end.to fail_with('expected "test.txt" to have file content: a string starting with "z"')
      end
    end
  end

  describe 'to_have_file_size' do
    context 'when file exists' do
      before :each do
        Aruba.platform.write_file(@file_path, '')
      end

      context 'and file size is equal' do
        it { expect(@file_name).to have_file_size(0) }
      end

      context 'and file size is not equal' do
        it { expect(@file_name).not_to have_file_size(1) }
      end
    end

    context 'when file does not exist' do
      it { expect(@file_name).not_to have_file_size(0) }
    end
  end

  describe "to have_same_file_content_as" do
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
        it { expect(file_name).to have_same_file_content_as reference_file }
      end

      context 'and this is not expected' do
        it do
          expect { expect(file_name).not_to have_same_file_content_as reference_file }.to raise_error RSpec::Expectations::ExpectationNotMetError
        end
      end
    end

    context 'when files are not the same' do
      let(:reference_file_content) { 'bar' }

      context 'and this is expected' do
        it { expect(file_name).not_to have_same_file_content_as reference_file }
      end

      context 'and this is not expected' do
        it do
          expect { expect(file_name).to have_same_file_content_as reference_file }.to raise_error RSpec::Expectations::ExpectationNotMetError
        end
      end
    end
  end

  describe "include a_file_with_same_content_as" do
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
        it { expect(files).to include a_file_with_same_content_as reference_file }
      end

      context 'and this is not expected' do
        it do
          expect { expect(files).not_to include a_file_with_same_content_as reference_file }
        end
      end
      
    end

    context 'when the array of files does not include a file with the same content' do
      let(:files) { [file_with_different_content] }

      context 'and this is expected' do
        it { expect(files).not_to include a_file_with_same_content_as reference_file }
      end

      context 'and this is not expected' do
        it do
          expect { expect(files).to include a_file_with_same_content_as reference_file }
        end
      end
    end
  end
end
