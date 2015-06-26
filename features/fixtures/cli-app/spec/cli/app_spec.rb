require 'spec_helper'

describe Cli::App do
  it 'has a version number' do
    expect(Cli::App::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(false).to eq(true)
  end
end
