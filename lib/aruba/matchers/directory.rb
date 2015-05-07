
RSpec::Matchers.define :be_existing_directory do |_|
  match do |actual|
    directory?(actual)
  end

  failure_message do |actual|
    format("expected that directory \"%s\" exists", actual)
  end

  failure_message_when_negated do |actual|
    format("expected that directory \"%s\" does not exist", actual)
  end
end
