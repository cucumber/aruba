# @private
RSpec::Matchers.define :have_same_file_content_like do |expected|
  match do |actual|
    FileUtils.compare_file(
      expand_path(actual),
      expand_path(expected)
    )
  end

  failure_message do |actual|
    format("expected that file \"%s\" is the same as file \"%s\".", actual, expected)
  end

  failure_message_when_negated do |actual|
    format("expected that file \"%s\" differs from file \"%s\".", actual, expected)
  end
end

RSpec::Matchers.define :be_existing_file do |_|
  match do |actual|
    File.file?(absolute_path(actual))
  end

  failure_message do |actual|
    format("expected that file \"%s\" exists", actual)
  end

  failure_message_when_negated do |actual|
    format("expected that file \"%s\" does not exist", actual)
  end
end

RSpec::Matchers.define :have_content do |expected|
  match do |actual|
    path = absolute_path(actual)

    next false unless File.file? path

    content = File.read(path).chomp
    next expected === content if expected.is_a? Regexp

    content == expected.chomp
  end

  failure_message do |actual|
    next format("expected that file \"%s\" contains:\n%s", actual, expected) if expected.is_a? Regexp

    format("expected that file \"%s\" contains exactly:\n%s", actual, expected)
  end

  failure_message_when_negated do |actual|
    next format("expected that file \"%s\" does not contain:\n%s", actual, expected) if expected.is_a? Regexp

    format("expected that file \"%s\" does not contains exactly:\n%s", actual, expected)
  end
end
