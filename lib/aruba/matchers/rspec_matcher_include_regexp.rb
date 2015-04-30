RSpec::Matchers.define :include_regexp do |expected|
  match do |actual|
    warn('The use of "include_regexp"-matchers is deprecated. It will be removed soon.')

    !actual.grep(expected).empty?
  end
end
