RSpec::Matchers.define :be_valid_option do |_|
  match do |actual|
    subject.option?(actual)
  end

  failure_message do |actual|
    format("expected that \"%s\" is a valid option", actual)
  end

  failure_message_when_negated do |actual|
    format("expected that \"%s\" is not a valid option", actual)
  end
end

RSpec::Matchers.define :have_option_value do |expected|
  match do |actual|
    @old_actual = actual
    @actual     = if RUBY_VERSION < '1.9'
                    subject.send(actual.to_sym)
                  else
                    subject.public_send(actual.to_sym)
                  end
    values_match? expected, @actual
  end

  diffable

  failure_message do |_actual|
    format(%(expected that option "%s" has value "%s"), @old_actual, expected)
  end

  failure_message_when_negated do |_actual|
    format(%(expected that option "%s" does not have value "%s"), @old_actual, expected)
  end
end
