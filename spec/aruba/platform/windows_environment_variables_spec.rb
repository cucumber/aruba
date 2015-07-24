require 'spec_helper'
require 'aruba/platforms/windows_environment_variables'

RSpec.describe Aruba::Platforms::WindowsEnvironmentVariables do
  subject(:environment) { described_class.new(old_environment) }

  describe '#[]' do
    context 'when environment contains uppercase variable' do
      let(:old_environment) { { 'MY_VARIABLE' => '1' } }

      context 'when uppercase key is given' do
        let(:variable) { 'MY_VARIABLE' }

        it { expect(environment[variable]).to eq '1' }
      end

      context 'when lowercase key is given' do
        let(:variable) { 'my_variable' }

        it { expect(environment[variable]).to eq '1' }
      end

      context 'when mixed case key is given' do
        let(:variable) { 'MY_variable' }

        it { expect(environment[variable]).to eq '1' }
      end

      context 'when unknown variable is given' do
        let(:variable) { 'unknown' }

        it { expect(environment[variable]).to eq nil }
      end
    end

    context 'when environment contains lowercase variable' do
      let(:old_environment) { { 'my_variable' => '1' } }

      context 'when uppercase key is given' do
        let(:variable) { 'MY_VARIABLE' }

        it { expect(environment[variable]).to eq '1' }
      end

      context 'when lowercase key is given' do
        let(:variable) { 'my_variable' }

        it { expect(environment[variable]).to eq '1' }
      end

      context 'when mixed case key is given' do
        let(:variable) { 'MY_variable' }

        it { expect(environment[variable]).to eq '1' }
      end

      context 'when unknown variable is given' do
        let(:variable) { 'unknown' }

        it { expect(environment[variable]).to eq nil }
      end
    end

    context 'when environment contains mixed case variable' do
      let(:old_environment) { { 'MY_variable' => '1' } }

      context 'when uppercase key is given' do
        let(:variable) { 'MY_VARIABLE' }

        it { expect(environment[variable]).to eq '1' }
      end

      context 'when lowercase key is given' do
        let(:variable) { 'my_variable' }

        it { expect(environment[variable]).to eq '1' }
      end

      context 'when mixed case key is given' do
        let(:variable) { 'MY_variable' }

        it { expect(environment[variable]).to eq '1' }
      end

      context 'when unknown variable is given' do
        let(:variable) { 'unknown' }

        it { expect(environment[variable]).to eq nil }
      end
    end
  end

  describe '#fetch' do
    context 'when environment contains uppercase variable' do
      let(:old_environment) { { 'MY_VARIABLE' => '1' } }

      context 'when uppercase key is given' do
        let(:variable) { 'MY_VARIABLE' }

        it { expect(environment.fetch(variable)).to eq '1' }
      end

      context 'when lowercase key is given' do
        let(:variable) { 'my_variable' }

        it { expect(environment.fetch(variable)).to eq '1' }
      end

      context 'when mixed case key is given' do
        let(:variable) { 'MY_variable' }

        it { expect(environment.fetch(variable)).to eq '1' }
      end

      context 'when unknown variable is given' do
        let(:variable) { 'unknown' }

        context 'and no default is given' do
          if RUBY_VERSION < '1.9'
            it { expect { environment.fetch(variable) }.to raise_error IndexError }
          else
            unless defined? KeyError
              class KeyError < StandardError; end
            end

            it { expect { environment.fetch(variable) }.to raise_error KeyError }
          end
        end

        context 'and default is given' do
          let(:default_value) { 'default_value' }

          it { expect(environment.fetch(variable, default_value)).to eq default_value }
        end
      end
    end

    context 'when environment contains lowercase variable' do
      let(:old_environment) { { 'my_variable' => '1' } }

      context 'when uppercase key is given' do
        let(:variable) { 'MY_VARIABLE' }

        it { expect(environment.fetch(variable)).to eq '1' }
      end

      context 'when lowercase key is given' do
        let(:variable) { 'my_variable' }

        it { expect(environment.fetch(variable)).to eq '1' }
      end

      context 'when mixed case key is given' do
        let(:variable) { 'MY_variable' }

        it { expect(environment.fetch(variable)).to eq '1' }
      end

      context 'when unknown variable is given' do
        let(:variable) { 'unknown' }

        context 'and no default is given' do
          if RUBY_VERSION < '1.9'
            it { expect { environment.fetch(variable) }.to raise_error IndexError }
          else
            unless defined? KeyError
              class KeyError < StandardError; end
            end

            it { expect { environment.fetch(variable) }.to raise_error KeyError }
          end
        end

        context 'and default is given' do
          let(:default_value) { 'default_value' }

          it { expect(environment.fetch(variable, default_value)).to eq default_value }
        end
      end
    end

    context 'when environment contains mixed case variable' do
      let(:old_environment) { { 'MY_variable' => '1' } }

      context 'when uppercase key is given' do
        let(:variable) { 'MY_VARIABLE' }

        it { expect(environment.fetch(variable)).to eq '1' }
      end

      context 'when lowercase key is given' do
        let(:variable) { 'my_variable' }

        it { expect(environment.fetch(variable)).to eq '1' }
      end

      context 'when mixed case key is given' do
        let(:variable) { 'MY_variable' }

        it { expect(environment.fetch(variable)).to eq '1' }
      end

      context 'when unknown variable is given' do
        let(:variable) { 'unknown' }

        context 'and no default is given' do
          if RUBY_VERSION < '1.9'
            it { expect { environment.fetch(variable) }.to raise_error IndexError }
          else
            unless defined? KeyError
              class KeyError < StandardError; end
            end

            it { expect { environment.fetch(variable) }.to raise_error KeyError }
          end
        end

        context 'and default is given' do
          let(:default_value) { 'default_value' }

          it { expect(environment.fetch(variable, default_value)).to eq default_value }
        end
      end
    end
  end

  describe '#key?' do
    context 'when environment contains uppercase variable' do
      let(:old_environment) { { 'MY_VARIABLE' => '1' } }

      context 'when uppercase key is given' do
        let(:variable) { 'MY_VARIABLE' }

        it { expect(environment).to be_key variable }
      end

      context 'when lowercase key is given' do
        let(:variable) { 'my_variable' }

        it { expect(environment).to be_key variable }
      end

      context 'when mixed case key is given' do
        let(:variable) { 'MY_variable' }

        it { expect(environment).to be_key variable }
      end

      context 'when unknown variable is given' do
        let(:variable) { 'unknown' }

        it { expect(environment).not_to be_key variable }
      end
    end

    context 'when environment contains lowercase variable' do
      let(:old_environment) { { 'my_variable' => '1' } }

      context 'when uppercase key is given' do
        let(:variable) { 'MY_VARIABLE' }

        it { expect(environment).to be_key variable }
      end

      context 'when lowercase key is given' do
        let(:variable) { 'my_variable' }

        it { expect(environment).to be_key variable }
      end

      context 'when mixed case key is given' do
        let(:variable) { 'MY_variable' }

        it { expect(environment).to be_key variable }
      end

      context 'when unknown variable is given' do
        let(:variable) { 'unknown' }

        it { expect(environment).not_to be_key variable }
      end
    end

    context 'when environment contains mixed case variable' do
      let(:old_environment) { { 'MY_variable' => '1' } }

      context 'when uppercase key is given' do
        let(:variable) { 'MY_VARIABLE' }

        it { expect(environment).to be_key variable }
      end

      context 'when lowercase key is given' do
        let(:variable) { 'my_variable' }

        it { expect(environment).to be_key variable }
      end

      context 'when mixed case key is given' do
        let(:variable) { 'MY_variable' }

        it { expect(environment).to be_key variable }
      end

      context 'when unknown variable is given' do
        let(:variable) { 'unknown' }

        it { expect(environment).not_to be_key variable }
      end
    end
  end

  describe '#append' do
    let(:value) { 'NEW_VALUE' }

    context 'when environment contains uppercase variable' do
      let(:old_environment) { { 'MY_VARIABLE' => '1' } }

      before(:each) { environment.append(variable, value) }

      context 'when uppercase key is given' do
        let(:variable) { 'MY_VARIABLE' }

        it { expect(environment[variable]).to eq '1NEW_VALUE' }
      end

      context 'when lowercase key is given' do
        let(:variable) { 'my_variable' }

        it { expect(environment[variable]).to eq '1NEW_VALUE' }
      end

      context 'when mixed case key is given' do
        let(:variable) { 'MY_variable' }

        it { expect(environment[variable]).to eq '1NEW_VALUE' }
      end

      context 'when unknown variable is given' do
        let(:variable) { 'unknown' }

        it { expect(environment[variable]).to eq 'NEW_VALUE' }
      end
    end

    context 'when environment contains lowercase variable' do
      let(:old_environment) { { 'my_variable' => '1' } }

      before(:each) { environment.append(variable, value) }

      context 'when uppercase key is given' do
        let(:variable) { 'MY_VARIABLE' }

        it { expect(environment[variable]).to eq '1NEW_VALUE' }
      end

      context 'when lowercase key is given' do
        let(:variable) { 'my_variable' }

        it { expect(environment[variable]).to eq '1NEW_VALUE' }
      end

      context 'when mixed case key is given' do
        let(:variable) { 'MY_variable' }

        it { expect(environment[variable]).to eq '1NEW_VALUE' }
      end

      context 'when unknown variable is given' do
        let(:variable) { 'unknown' }

        it { expect(environment[variable]).to eq 'NEW_VALUE' }
      end
    end

    context 'when environment contains mixed case variable' do
      let(:old_environment) { { 'MY_variable' => '1' } }

      before(:each) { environment.append(variable, value) }

      context 'when uppercase key is given' do
        let(:variable) { 'MY_VARIABLE' }

        it { expect(environment[variable]).to eq '1NEW_VALUE' }
      end

      context 'when lowercase key is given' do
        let(:variable) { 'my_variable' }

        it { expect(environment[variable]).to eq '1NEW_VALUE' }
      end

      context 'when mixed case key is given' do
        let(:variable) { 'MY_variable' }

        it { expect(environment[variable]).to eq '1NEW_VALUE' }
      end

      context 'when unknown variable is given' do
        let(:variable) { 'unknown' }

        it { expect(environment[variable]).to eq 'NEW_VALUE' }
      end
    end
  end

  describe '#prepend' do
    let(:value) { 'NEW_VALUE' }

    context 'when environment contains uppercase variable' do
      let(:old_environment) { { 'MY_VARIABLE' => '1' } }

      before(:each) { environment.prepend(variable, value) }

      context 'when uppercase key is given' do
        let(:variable) { 'MY_VARIABLE' }

        it { expect(environment[variable]).to eq 'NEW_VALUE1' }
      end

      context 'when lowercase key is given' do
        let(:variable) { 'my_variable' }

        it { expect(environment[variable]).to eq 'NEW_VALUE1' }
      end

      context 'when mixed case key is given' do
        let(:variable) { 'MY_variable' }

        it { expect(environment[variable]).to eq 'NEW_VALUE1' }
      end

      context 'when unknown variable is given' do
        let(:variable) { 'unknown' }

        it { expect(environment[variable]).to eq 'NEW_VALUE' }
      end
    end

    context 'when environment contains lowercase variable' do
      let(:old_environment) { { 'my_variable' => '1' } }

      before(:each) { environment.prepend(variable, value) }

      context 'when uppercase key is given' do
        let(:variable) { 'MY_VARIABLE' }

        it { expect(environment[variable]).to eq 'NEW_VALUE1' }
      end

      context 'when lowercase key is given' do
        let(:variable) { 'my_variable' }

        it { expect(environment[variable]).to eq 'NEW_VALUE1' }
      end

      context 'when mixed case key is given' do
        let(:variable) { 'MY_variable' }

        it { expect(environment[variable]).to eq 'NEW_VALUE1' }
      end

      context 'when unknown variable is given' do
        let(:variable) { 'unknown' }

        it { expect(environment[variable]).to eq 'NEW_VALUE' }
      end
    end

    context 'when environment contains mixed case variable' do
      let(:old_environment) { { 'MY_variable' => '1' } }

      before(:each) { environment.prepend(variable, value) }

      context 'when uppercase key is given' do
        let(:variable) { 'MY_VARIABLE' }

        it { expect(environment[variable]).to eq 'NEW_VALUE1' }
      end

      context 'when lowercase key is given' do
        let(:variable) { 'my_variable' }

        it { expect(environment[variable]).to eq 'NEW_VALUE1' }
      end

      context 'when mixed case key is given' do
        let(:variable) { 'MY_variable' }

        it { expect(environment[variable]).to eq 'NEW_VALUE1' }
      end

      context 'when unknown variable is given' do
        let(:variable) { 'unknown' }

        it { expect(environment[variable]).to eq 'NEW_VALUE' }
      end
    end
  end
end
