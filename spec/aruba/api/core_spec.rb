require 'spec_helper'
require 'aruba/api'
require 'fileutils'

RSpec.describe Aruba::Api::Core do
  include_context 'uses aruba API'

  describe '#cd' do
    before do
      @directory_name = 'test_dir'
      @directory_path = File.join(@aruba.aruba.current_directory, @directory_name)
    end

    context 'with a block given' do
      it 'runs the passed block in the given directory' do
        @aruba.create_directory @directory_name
        full_path = File.expand_path(@directory_path)
        @aruba.cd @directory_name do
          expect(Dir.pwd).to eq full_path
        end
        expect(Dir.pwd).not_to eq full_path
      end

      it 'sets directory environment in the passed block' do
        @aruba.create_directory @directory_name
        old_pwd = ENV['PWD']
        full_path = File.expand_path(@directory_path)
        @aruba.cd @directory_name do
          expect(ENV['PWD']).to eq full_path
          expect(ENV['OLDPWD']).to eq old_pwd
        end
      end

      it 'sets aruba environment in the passed block' do
        @aruba.create_directory @directory_name
        @aruba.set_environment_variable('FOO', 'bar')
        @aruba.cd @directory_name do
          expect(ENV['FOO']).to eq 'bar'
        end
      end

      it 'does not touch other environment variables in the passed block' do
        keys = ENV.keys - ['PWD', 'OLDPWD']
        old_values = ENV.values_at(*keys)
        @aruba.create_directory @directory_name
        @aruba.cd @directory_name do
          expect(ENV.values_at(*keys)).to eq old_values
        end
      end
    end
  end

  describe '#expand_path' do
    context 'when file_name is given' do
      it { expect(@aruba.expand_path(@file_name)).to eq File.expand_path(@file_path) }
    end

    context 'when file_path is given' do
      it { expect(@aruba.expand_path(@file_path)).to eq @file_path }
    end

    context 'when path contains "."' do
      it { expect(@aruba.expand_path('.')).to eq File.expand_path(aruba.current_directory) }
    end

    context 'when path contains ".."' do
      it { expect(@aruba.expand_path('path/..')).to eq File.expand_path(File.join(aruba.current_directory)) }
    end

    context 'when path is nil' do
      it { expect { @aruba.expand_path(nil) }.to raise_error ArgumentError }
    end

    context 'when path is empty' do
      it { expect { @aruba.expand_path('') }.to raise_error ArgumentError }
    end

    context 'when second argument is given' do
      it 'behaves similar to File.expand_path' do
        expect(@aruba.expand_path(@file_name, 'path')).
          to eq File.expand_path(File.join(aruba.current_directory, 'path', @file_name))
      end
    end

    context 'when file_name contains fixtures "%" string' do
      it 'finds files in the fixtures directory' do
        expect(@aruba.expand_path('%/cli-app')).
          to eq File.expand_path('cli-app', File.join(aruba.fixtures_directory))
      end
    end
  end

  describe '#in_current_directory' do
    let(:directory_path) { @aruba.aruba.current_directory }
    let!(:full_path) { File.expand_path(directory_path) }

    context 'with a block given' do
      it 'runs the passed block in the given directory' do
        @aruba.in_current_directory do
          expect(Dir.pwd).to eq full_path
        end
        expect(Dir.pwd).not_to eq full_path
      end

      it 'sets directory environment in the passed block' do
        old_pwd = ENV['PWD']
        @aruba.in_current_directory do
          expect(ENV['PWD']).to eq full_path
          expect(ENV['OLDPWD']).to eq old_pwd
        end
      end

      it 'sets aruba environment in the passed block' do
        @aruba.set_environment_variable('FOO', 'bar')
        @aruba.in_current_directory do
          expect(ENV['FOO']).to eq 'bar'
        end
      end

      it 'does not touch other environment variables in the passed block' do
        keys = ENV.keys - ['PWD', 'OLDPWD']
        old_values = ENV.values_at(*keys)
        @aruba.in_current_directory do
          expect(ENV.values_at(*keys)).to eq old_values
        end
      end
    end
  end

  describe '#with_environment' do
    it 'modifies env for block' do
      variable = 'THIS_IS_A_ENV_VAR_1'
      ENV[variable] = '1'

      @aruba.with_environment variable => '0' do
        expect(ENV[variable]).to eq '0'
      end

      expect(ENV[variable]).to eq '1'
    end

    it 'works together with #set_environment_variable' do
      variable = 'THIS_IS_A_ENV_VAR_2'
      @aruba.set_environment_variable variable, '1'

      @aruba.with_environment do
        expect(ENV[variable]).to eq '1'
        @aruba.set_environment_variable variable, '0'
        @aruba.with_environment do
          expect(ENV[variable]).to eq '0'
        end
        expect(ENV[variable]).to eq '1'
      end
    end

    it 'works with a mix of ENV and #set_environment_variable' do
      variable = 'THIS_IS_A_ENV_VAR_3'
      @aruba.set_environment_variable variable, '1'
      ENV[variable] = '2'
      expect(ENV[variable]).to eq '2'

      @aruba.with_environment do
        expect(ENV[variable]).to eq '1'
        @aruba.set_environment_variable variable, '0'
        @aruba.with_environment do
          expect(ENV[variable]).to eq '0'
        end
        expect(ENV[variable]).to eq '1'
      end
      expect(ENV[variable]).to eq '2'
    end

    it 'keeps values not set in argument' do
      variable = 'THIS_IS_A_ENV_VAR_4'
      ENV[variable] = '2'
      expect(ENV[variable]).to eq '2'

      @aruba.with_environment do
        expect(ENV[variable]).to eq '2'
      end
      expect(ENV[variable]).to eq '2'
    end
  end
end
