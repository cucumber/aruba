require 'cucumber/platform'

Before '@requires-ruby-version-193' do
  next unless RUBY_VERSION < '1.9.3'

  if Cucumber::VERSION < '2'
    pending
  else
    skip_this_scenario
  end
end
