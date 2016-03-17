# Cucumber
Then /^the feature(?:s)? should( not)?(?: all)? pass$/ do |negated|
  if negated
    step 'the output should contain " failed)"'
    step 'the exit status should be 1'
  else
    step 'the output should not contain " failed)"'
    step 'the output should not contain " undefined)"'
    step 'the exit status should be 0'
  end
end

# Cucumber
Then /^the feature(?:s)? should( not)?(?: all)? pass with( regex)?:$/ do |negated, regex, string|
  if negated
    step 'the output should contain " failed)"'
    step 'the exit status should be 1'
  else
    step 'the output should not contain " failed)"'
    step 'the output should not contain " undefined)"'
    step 'the exit status should be 0'
  end

  if regex
    step "the output should match %r<#{string}>"
  else
    step 'the output should contain:', string
  end
end

# RSpec
Then /^the spec(?:s)? should( not)?(?: all)? pass(?: with (\d+) failures?)?$/ do |negated, count_failures|
  if negated
    if count_failures.nil?
      step 'the output should not contain "0 failures"'
    else
      step %(the output should contain "#{count_failures} failures")
    end

    step 'the exit status should be 1'
  else
    step 'the output should contain "0 failures"'
    step 'the exit status should be 0'
  end
end

# RSpec
Then /^the spec(?:s)? should( not)?(?: all)? pass with( regex)?:$/ do |negated, regex, string|
  if negated
    step 'the output should not contain "0 failures"'
    step 'the exit status should be 1'
  else
    step 'the output should contain "0 failures"'
    step 'the exit status should be 0'
  end

  if regex
    step "the output should match %r<#{string}>"
  else
    step 'the output should contain:', string
  end
end

# Minitest
Then /^the tests(?:s)? should( not)?(?: all)? pass(?: with (\d+) failures?)?$/ do |negated, count_failures|
  if negated
    if count_failures.nil?
      step 'the output should not contain "0 errors"'
    else
      step %(the output should contain "#{count_failures} errors")
    end

    step 'the exit status should be 1'
  else
    step 'the output should contain "0 errors"'
    step 'the exit status should be 0'
  end
end

# Minitest
Then /^the test(?:s)? should( not)?(?: all)? pass with( regex)?:$/ do |negated, regex, string|
  if negated
    step 'the output should contain "0 errors"'
    step 'the exit status should be 1'
  else
    step 'the output should not contain "0 errors"'
    step 'the exit status should be 0'
  end

  if regex
    step "the output should match %r<#{string}>"
  else
    step 'the output should contain:', string
  end
end
