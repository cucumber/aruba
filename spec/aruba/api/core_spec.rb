require 'spec_helper'
require 'aruba/api'
require 'fileutils'

describe Aruba::Api::Core do
  include_context 'uses aruba API'

  describe '#cd' do
    before(:each) do
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

      it 'does not touch non-directory environment of the passed block' do
        @aruba.create_directory @directory_name
        @aruba.cd @directory_name do
          expect(ENV['HOME']).not_to be_nil
        end
      end
    end
  end

  describe '#expand_path' do
    context 'when file_name is given' do
      it { expect(@aruba.expand_path(@file_name)).to eq File.expand_path(@file_path) }
    end

    context 'when an absolute file_path is given' do
      let(:logger) { @aruba.aruba.logger }

      before do
        allow(@aruba.aruba.logger).to receive :warn
      end

      it { expect(@aruba.expand_path(@file_path)).to eq @file_path }

      it 'warns about it' do
        @aruba.expand_path(@file_path)
        expect(logger).to have_received(:warn).with(/Using absolute paths in Aruba is not recommended/)
      end

      it 'does not warn about it if told not to' do
        @aruba.aruba.config.allow_absolute_paths = true
        @aruba.expand_path(@file_path)
        expect(logger).not_to have_received(:warn)
      end
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

    context 'when dir_path is given similar to File.expand_path ' do
      it { expect(@aruba.expand_path(@file_name, 'path')).to eq File.expand_path(File.join(aruba.current_directory, 'path', @file_name)) }
    end

    context 'when file_name contains fixtures "%" string' do
      let(:runtime) { instance_double('Aruba::Runtime') }
      let(:config) { double('Aruba::Config') }
      let(:environment) { instance_double('Aruba::Environment') }

      let(:klass) do
        Class.new do
          include Aruba::Api

          attr_reader :aruba

          def initialize(aruba)
            @aruba = aruba
          end
        end
      end

      before :each do
        allow(config).to receive(:fixtures_path_prefix).and_return('%')
        allow(config).to receive(:root_directory).and_return aruba.config.root_directory
        allow(config).to receive(:working_directory).and_return aruba.config.working_directory
      end

      before :each do
        allow(environment).to receive(:clear)
        allow(environment).to receive(:update).and_return(environment)
        allow(environment).to receive(:to_h).and_return('PATH' => aruba.current_directory.to_s)
      end

      before :each do
        allow(runtime).to receive(:config).and_return config
        allow(runtime).to receive(:environment).and_return environment
        allow(runtime).to receive(:current_directory).and_return aruba.current_directory
        allow(runtime).to receive(:root_directory).and_return aruba.root_directory
        allow(runtime).to receive(:fixtures_directory).and_return File.join(aruba.root_directory, aruba.current_directory, 'spec', 'fixtures')
      end

      before :each do
        @aruba = klass.new(runtime)
        @aruba.touch 'spec/fixtures/file1'
      end

      it { expect(@aruba.expand_path('%/file1')).to eq File.expand_path(File.join(aruba.current_directory, 'spec', 'fixtures', 'file1')) }
    end
  end

  describe '#with_environment' do
    it 'modifies env for block' do
      variable = 'THIS_IS_A_ENV_VAR'
      ENV[variable] = '1'

      @aruba.with_environment variable => '0' do
        expect(ENV[variable]).to eq '0'
      end

      expect(ENV[variable]).to eq '1'
    end

    it 'works together with #set_environment_variable' do
      variable = 'THIS_IS_A_ENV_VAR'
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
      variable = 'THIS_IS_A_ENV_VAR'
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
      variable = 'THIS_IS_A_ENV_VAR'
      ENV[variable] = '2'
      expect(ENV[variable]).to eq '2'

      @aruba.with_environment do
        expect(ENV[variable]).to eq '2'
      end
      expect(ENV[variable]).to eq '2'
    end
  end
end
