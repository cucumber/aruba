require 'aruba/api'

World(Aruba::Api)

Before('@disable-bundler') do
  unset_bundler_env_vars
end

Before do
  @__aruba_original_paths = (ENV['PATH'] || '').split(File::PATH_SEPARATOR)
  ENV['PATH'] = ([File.expand_path('bin')] + @__aruba_original_paths).join(File::PATH_SEPARATOR)
end

After do
  ENV['PATH'] = @__aruba_original_paths.join(File::PATH_SEPARATOR)
end

Before do
  FileUtils.rm_rf(current_dir)
end

Before('@puts') do
  @puts = true
end

Before('@announce-cmd') do
  @announce_cmd = true
end

Before('@announce-stdout') do
  @announce_stdout = true
end

Before('@announce-stderr') do
  @announce_stderr = true
end

Before('@announce-dir') do
  @announce_dir = true
end

Before('@announce-env') do
  @announce_env = true
end

Before('@announce') do
  @announce_stdout = true
  @announce_stderr = true
  @announce_cmd = true
  @announce_dir = true
  @announce_env = true
end

After do
  restore_env
end

Given /^I'm using a clean gemset "([^"]*)"$/ do |gemset|
  use_clean_gemset(gemset)
end

Given /^a directory named "([^"]*)"$/ do |dir_name|
  create_dir(dir_name)
end

Given /^a file named "([^"]*)" with:$/ do |file_name, file_content|
  create_file(file_name, file_content)
end

Given /^an empty file named "([^"]*)"$/ do |file_name|
  create_file(file_name, "")
end

When /^I write to "([^"]*)" with:$/ do |file_name, file_content|
  create_file(file_name, file_content, false)
end

When /^I overwrite "([^"]*)" with:$/ do |file_name, file_content|
  create_file(file_name, file_content, true)
end

When /^I append to "([^"]*)" with:$/ do |file_name, file_content|
  append_to_file(file_name, file_content)
end

When /^I cd to "([^"]*)"$/ do |dir|
  cd(dir)
end

When /^I run "(.*)"$/ do |cmd|
  run(unescape(cmd), false)
end

When /^I successfully run "(.*)"$/ do |cmd|
  run(unescape(cmd))
end

When /^I run "([^"]*)" interactively$/ do |cmd|
  run_interactive(unescape(cmd))
end

When /^I type "([^"]*)"$/ do |input|
  write_interactive(ensure_newline(input))
end

#(\w+ |\".*?\"|'.*?')
#(\w+)|(?:')(.+)(?:')|(?: )(\w+)|(\w+)(?: )

Then /^the output should(, regardless of case,|) contain "([^"]*)"( each of these|)$/ do |case_insensitive, partial_output, is_array|
  (is_array == nil ? [partial_output] : partial_output.scan(/(\w+)|(?:')(.+)(?:')/).flatten.compact).each do |partial_output_each|
    assert_partial_output(partial_output_each, (case_insensitive == "" ? :case_sensitive : :case_insensitive))
  end
end

Then /^the output should not(, regardless of case,|) contain "([^"]*)"$/ do |case_insensitive, partial_output|
  combined_output.should_not =~ regexp(partial_output, (case_insensitive == "" ? :case_sensitive : :case_insensitive))
end

Then /^the output should(, regardless of case,|) contain:$/ do |case_insensitive, partial_output|
  combined_output.should =~ regexp(partial_output, (case_insensitive == "" ? :case_sensitive : :case_insensitive))
end

Then /^the output should not(, regardless of case,|) contain:$/ do |case_insensitive, partial_output|
  combined_output.should_not =~ regexp(partial_output, (case_insensitive == "" ? :case_sensitive : :case_insensitive))
end

Then /^the output should(, regardless of case,|) contain exactly "([^"]*)"$/ do |case_insensitive, exact_output|
  combined_output.should == unescape(exact_output) if case_insensitive == ""
  combined_output.downcase.should == unescape(exact_output).downcase if case_insensitive != nil
end

Then /^the output should(, regardless of case,|) contain exactly:$/ do |case_insensitive, exact_output|
  combined_output.should == exact_output if case_insensitive == ""  
  combined_output.downcase.should == exact_output.downcase if case_insensitive == ""  
end

# "the output should match" allows regex in the partial_output, if
# you don't need regex, use "the output should contain" instead since
# that way, you don't have to escape regex characters that
# appear naturally in the output
Then /^the output should match \/([^\/]*)\/$/ do |partial_output|
  combined_output.should =~ /#{partial_output}/
end

Then /^the output should match \/([^\/]*)\/i$/ do |partial_output|
  combined_output.should =~ /#{partial_output}/i
end

Then /^the output should not match \/([^\/]*)\/$/ do |partial_output|
  combined_output.should_not =~ /#{partial_output}/
end

Then /^the output should not match \/([^\/]*)\/i$/ do |partial_output|
  combined_output.should_not =~ /#{partial_output}/i
end

Then /^the output should(, regardless of case,|) match:$/ do |case_insensitive, partial_output|
 combined_output.should =~ (case_insensitive == "" ? /#{partial_output}/m : /#{partial_output}/mi)
end

Then /^the output should not(, regardless of case,|) match:$/ do |case_insensitive, partial_output|
 combined_output.should_not =~ (case_insensitive == "" ? /#{partial_output}/m : /#{partial_output}/mi)
end

Then /^the exit status should be (\d+)$/ do |exit_status|
  @last_exit_status.should == exit_status.to_i
end

Then /^the exit status should not be (\d+)$/ do |exit_status|
  @last_exit_status.should_not == exit_status.to_i
end

Then /^it should(, regardless of case,|) (pass|fail) with:$/ do |case_insensitive, pass_fail, partial_output|
  self.__send__("assert_#{pass_fail}ing_with", partial_output, (case_insensitive == "" ? :case_sensitive : :case_insensitive))
end

Then /^it should(, regardless of case,|) (pass|fail) with regexp?:$/ do |case_insensitive, pass_fail, partial_output|
  Then "the output should#{case_insensitive} match:", partial_output
  if pass_fail == 'pass'
    @last_exit_status.should == 0
  else
    @last_exit_status.should_not == 0
  end
end

Then /^the stderr should(, regardless of case,|) contain "([^"]*)"$/ do |case_insensitive, partial_output|
  @last_stderr.should =~ regexp(partial_output, (case_insensitive == "" ? :case_sensitive : :case_insensitive))
end

Then /^the stdout should(, regardless of case,|) contain "([^"]*)"$/ do |case_insensitive, partial_output|
  @last_stdout.should =~ regexp(partial_output, (case_insensitive == "" ? :case_sensitive : :case_insensitive))
end

Then /^the stderr should not(, regardless of case,|) contain "([^"]*)"$/ do |case_insensitive, partial_output|
  @last_stderr.should_not =~ regexp(partial_output, (case_insensitive == "" ? :case_sensitive : :case_insensitive))
end

Then /^the stdout should not(, regardless of case,|) contain "([^"]*)"$/ do |case_insensitive, partial_output|
  @last_stdout.should_not =~ regexp(partial_output, (case_insensitive == "" ? :case_sensitive : :case_insensitive))
end

Then /^the following files should exist:$/ do |files|
  check_file_presence(files.raw.map{|file_row| file_row[0]}, true)
end

Then /^the following files should not exist:$/ do |files|
  check_file_presence(files.raw.map{|file_row| file_row[0]}, false)
end

Then /^the following directories should exist:$/ do |directories|
  check_directory_presence(directories.raw.map{|directory_row| directory_row[0]}, true)
end

Then /^the following directories should not exist:$/ do |directories|
  check_directory_presence(directories.raw.map{|directory_row| directory_row[0]}, false)
end

Then /^the file "([^"]*)" should contain "([^"]*)"$/ do |file, partial_content|
  check_file_content(file, partial_content, true)
end

Then /^the file "([^"]*)" should not contain "([^"]*)"$/ do |file, partial_content|
  check_file_content(file, partial_content, false)
end

Then /^the file "([^"]*)" should contain exactly:$/ do |file, exact_content|
  check_exact_file_content(file, exact_content)
end

Then /^the file "([^"]*)" should match \/([^\/]*)\/$/ do |file, partial_content|
  check_file_content(file, /#{partial_content}/, true)
end

Then /^the file "([^"]*)" should not match \/([^\/]*)\/$/ do |file, partial_content|
  check_file_content(file, /#{partial_content}/, false)
end
