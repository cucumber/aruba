require 'spec_helper'

describe Cli::App do
  it 'has a version number' do
    expect(Cli::App::VERSION).not_to be nil
  end
end
