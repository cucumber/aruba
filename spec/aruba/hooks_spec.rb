require 'spec_helper'

describe Aruba::Hooks do
  let(:hooks) { described_class.new }

  it 'executes a stored hook' do
    hook_was_run = false
    hooks.append :hook_label, -> { hook_was_run = true }
    hooks.execute :hook_label, self
    expect(hook_was_run).to be_truthy
  end

  it 'executes a stored hook that takes multiple arguments' do
    hook_values = []
    hooks.append :hook_label, ->(a, b, c) { hook_values = [a, b, c] }
    hooks.execute :hook_label, self, 1, 2, 3
    expect(hook_values).to eq [1, 2, 3]
  end
end
