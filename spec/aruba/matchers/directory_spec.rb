require 'spec_helper'
require 'aruba/matchers/directory'
require 'fileutils'

RSpec.describe 'Directory Matchers' do
  include_context 'uses aruba API'
  include_context 'needs to expand paths'

  describe 'to_be_an_existing_directory' do
    let(:name) { 'test.d' }
    let(:path) { @aruba.expand_path(name) }

    context 'when directory exists' do
      before :each do
        FileUtils.mkdir_p path
      end

      it { expect(name).to be_an_existing_directory }
    end

    context 'when directory does not exist' do
      it { expect(name).not_to be_an_existing_directory }
    end
  end

  describe 'to_have_sub_directory' do
    let(:name) { 'test.d' }
    let(:path) { @aruba.expand_path(name) }
    let(:content) { %w(subdir.1.d subdir.2.d) }

    context 'when directory exists' do
      before :each do
        FileUtils.mkdir_p path
      end

      before :each do
        Array(content).each { |p| Dir.mkdir File.join(path, p) }
      end

      context 'when single directory' do
        it { expect(name).to have_sub_directory('subdir.1.d') }
      end

      context 'when multiple directories' do
        it { expect(name).to have_sub_directory(['subdir.1.d', 'subdir.2.d']) }
      end

      context 'when non existing directory' do
        it { expect(name).not_to have_sub_directory('subdir.3.d') }
      end
    end

    context 'when directory does not exist' do
      it { expect(name).not_to have_sub_directory('subdir') }
    end
  end
end
