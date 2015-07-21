Given(/I use (?:a|the) fixture(?: named)? "([^"]*)"/) do |name|
  copy File.join(aruba.config.fixtures_path_prefix, name), name
  cd name
end

Given(/^(?:a|the) directory(?: named)? "([^"]*)"$/) do |dir_name|
  create_directory(dir_name)
end

Given(/^(?:a|the) directory(?: named)? "([^"]*)" with mode "([^"]*)"$/) do |dir_name, dir_mode|
  create_directory(dir_name)
  chmod(dir_mode, dir_name)
end

Given(/^(?:a|the) file(?: named)? "([^"]*)" with:$/) do |file_name, file_content|
  write_file(file_name, file_content)
end

Given(/^(?:an|the) executable(?: named)? "([^"]*)" with:$/) do |file_name, file_content|
  step %(a file named "#{file_name}" with mode "0755" and with:), file_content
end

Given(/^(?:a|the) file(?: named)? "([^"]*)" with "([^"]*)"$/) do |file_name, file_content|
  write_file(file_name, Aruba::Platform.unescape(file_content))
end

Given(/^(?:a|the) file(?: named)? "([^"]*)" with mode "([^"]*)" and with:$/) do |file_name, file_mode, file_content|
  write_file(file_name, file_content)
  chmod(file_mode, file_name)
end

Given(/^(?:a|the) (\d+) byte file(?: named)? "([^"]*)"$/) do |file_size, file_name|
  write_fixed_size_file(file_name, file_size.to_i)
end

Given(/^(?:an|the) empty file(?: named)? "([^"]*)"$/) do |file_name|
  write_file(file_name, "")
end

Given(/^(?:an|the) empty file(?: named)? "([^"]*)" with mode "([^"]*)"$/) do |file_name, file_mode|
  write_file(file_name, "")
  chmod(file_mode, file_name)
end

Given(/^(?:a|the) directory(?: named)? "([^"]*)" does not exist$/) do |directory_name|
  remove(directory_name, :force => true)
end

When(/^I write to "([^"]*)" with:$/) do |file_name, file_content|
  write_file(file_name, file_content)
end

When(/^I overwrite "([^"]*)" with:$/) do |file_name, file_content|
  overwrite_file(file_name, file_content)
end

When(/^I append to "([^"]*)" with:$/) do |file_name, file_content|
  append_to_file(file_name, file_content)
end

When(/^I append to "([^"]*)" with "([^"]*)"$/) do |file_name, file_content|
  append_to_file(file_name, file_content)
end

When(/^I remove (?:a|the) file(?: named)? "([^"]*)"$/) do |file_name|
  remove(file_name)
end

Given(/^(?:a|the) file(?: named)? "([^"]*)" does not exist$/) do |file_name|
  remove(file_name, :force => true)
end

When(/^I remove (?:a|the) directory(?: named)? "(.*?)"$/) do |directory_name|
  remove(directory_name)
end

When(/^I cd to "([^"]*)"$/) do |dir|
  cd(dir)
end

Then(/^the following files should (not )?exist:$/) do |negated, files|
  files = files.rows.flatten

  if negated
    expect(files).not_to include an_existing_file
  else
    expect(files).to all be_an_existing_file
  end
end

Then(/^(?:a|the) file(?: named)? "([^"]*)" should (not )?exist$/) do |file, expect_match|
  if expect_match
    expect(file).not_to be_an_existing_file
  else
    expect(file).to be_an_existing_file
  end
end

Then(/^(?:a|the) file matching %r<(.*?)> should (not )?exist$/) do |pattern, expect_match|
  if expect_match
    expect(all_paths).not_to include match Regexp.new(pattern)
  else
    expect(all_paths).to include match Regexp.new(pattern)
  end
end

Then(/^(?:a|the) (\d+) byte file(?: named)? "([^"]*)" should (not )?exist$/) do |size, file, negated|
  if negated
    expect(file).not_to have_file_size(size)
  else
    expect(file).to have_file_size(size)
  end
end

Then(/^the following directories should (not )?exist:$/) do |negated, directories|
  directories = directories.rows.flatten

  if negated
    expect(directories).not_to include an_existing_directory
  else
    expect(directories).to all be_an_existing_directory
  end
end

Then(/^(?:a|the) directory(?: named)? "([^"]*)" should (not )?exist$/) do |directory, negated|
  if negated
    expect(directory).not_to be_an_existing_directory
  else
    expect(directory).to be_an_existing_directory
  end
end

Then(/^(?:a|the) file(?: named)? "([^"]*)" should (not )?contain "([^"]*)"$/) do |file, negated, content|
  if negated
    expect(file).not_to have_file_content Regexp.new(Regexp.escape(content.chomp))
  else
    expect(file).to have_file_content Regexp.new(Regexp.escape(content.chomp))
  end
end

Then(/^(?:a|the) file(?: named)? "([^"]*)" should (not )?contain:$/) do |file, negated, content|
  if negated
    expect(file).not_to have_file_content Regexp.new(Regexp.escape(content.chomp))
  else
    expect(file).to have_file_content Regexp.new(Regexp.escape(content.chomp))
  end
end

Then(/^(?:a|the) file(?: named)? "([^"]*)" should (not )?contain exactly:$/) do |file, negated, content|
  if negated
    expect(file).not_to have_file_content content
  else
    expect(file).to have_file_content content
  end
end

Then(/^(?:a|the) file(?: named)? "([^"]*)" should (not )?match %r<([^\/]*)>$/) do |file, negated, content|
  if negated
    expect(file).not_to have_file_content Regexp.new(content)
  else
    expect(file).to have_file_content Regexp.new(content)
  end
end

Then(/^(?:a|the) file(?: named)? "([^"]*)" should (not )?match \/([^\/]*)\/$/) do |file, negated, content|
  if negated
    expect(file).not_to have_file_content Regexp.new(content)
  else
    expect(file).to have_file_content Regexp.new(content)
  end
end

Then(/^(?:a|the) file(?: named)? "([^"]*)" should (not )?be equal to file "([^"]*)"/) do |file, negated, reference_file|
  if negated
    expect(file).not_to have_same_file_content_like(reference_file)
  else
    expect(file).to have_same_file_content_like(reference_file)
  end
end

Then(/^the mode of filesystem object "([^"]*)" should (not )?match "([^"]*)"$/) do |file, negated, permissions|
  if negated
    expect(file).not_to have_permissions(permissions)
  else
    expect(file).to have_permissions(permissions)
  end
end

Then(/^the (?:file|directory)(?: named)? "([^"]*)" should have permissions "([^"]*)"$/) do |path, negated, permissions|
  if negated
    expect(path).not_to have_permissions(permissions)
  else
    expect(path).to have_permissions(permissions)
  end
end
