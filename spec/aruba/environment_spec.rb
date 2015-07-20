require 'aruba/environment'
require 'spec_helper'

describe Aruba::Environment do
  subject(:env) { described_class.new  }

  it { expect(env['PATH']).not_to be_nil}

  it { expect(env.clear.to_h).to be_empty}
end
