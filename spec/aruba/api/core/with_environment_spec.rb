require 'spec_helper'
require 'securerandom'
require 'aruba/api'
require 'fileutils'

describe Aruba::Api do
  include_context 'uses aruba API'

  context '#with_environment' do
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
