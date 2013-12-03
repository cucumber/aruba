RSpec::Matchers.define :be_an_existing_file do
  match do |actual|
    File.exists? actual
  end

  failure_message_for_should do |actual|
    "expected that a file \"#{actual}\" exists"
  end

  failure_message_for_should_not do |actual|
    "expected that a file \"#{actual}\" does not exist"
  end

  description do
    "be an existing file"
  end
end
