RSpec::Matchers.define :include_file_matching do |expected|
  match do |actual|
    ! actual.grep( Regexp.new( expected ) ).empty?
  end

  failure_message_for_should do |actual|
    "expected that a file matching #{expected.inspect} exists"
  end

  failure_message_for_should_not do |actual|
    "expected that a file matching #{expected.inspect} does not exist"
  end

  description do
    "be an existing file matching #{expected.inspect} available"
  end
end
