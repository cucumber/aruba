require 'spec_helper'
require 'securerandom'
require 'aruba/api'
require 'fileutils'

describe Aruba::Api do
  include_context 'uses aruba API'

  describe 'directories' do
    before(:each) do
      @directory_name = 'test_dir'
      @directory_path = File.join(@aruba.aruba.current_directory, @directory_name)
    end

    describe '#cd' do
      context 'with a block given' do
        it 'runs the passed block in the given directory' do
          @aruba.create_directory @directory_name
          full_path = File.expand_path(@directory_path)
          @aruba.cd @directory_name do
            expect(Dir.pwd).to eq full_path
          end
          expect(Dir.pwd).not_to eq full_path
        end

        it 'does not touch non-directory environment the passed block' do
          @aruba.create_directory @directory_name
          @aruba.cd @directory_name do
            expect(ENV['HOME']).not_to be_nil
          end
        end
      end
    end
  end
end
