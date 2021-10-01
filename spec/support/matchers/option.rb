RSpec::Matchers.define :be_valid_option do |_|
  match do |actual|
    subject.option?(actual)
  end

  failure_message do |actual|
    format('expected that "%s" is a valid option', actual)
  end

  failure_message_when_negated do |actual|
    format('expected that "%s" is not a valid option', actual)
  end
end
