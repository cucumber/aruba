When /^I run a simple fixture interactively$/ do
  command = %%#{Dir.pwd}/features/fixtures/simple%
  When "I run `#{command}` interactively"
end
