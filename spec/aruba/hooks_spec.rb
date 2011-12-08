require 'aruba/config'

describe Aruba::Hooks do
  it 'executes a stored hook' do
    hook_was_run = false
    subject.append :hook_label, lambda { hook_was_run = true }
    subject.execute :hook_label, self
    hook_was_run.should be_true
  end

  it 'executes a stored hook that takes multiple arguments' do
    hook_values = []
    subject.append :hook_label, lambda { |a,b,c| hook_values = [a,b,c] }
    subject.execute :hook_label, self, 1, 2, 3
    hook_values.should == [1,2,3]
  end

end
