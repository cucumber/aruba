RSpec::Matchers.define :include_regexp do |expected|
  match do |actual|
    ! actual.grep(expected).empty?
  end
end
