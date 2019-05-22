Given(/^I use (?:a|the) fixture(?: named)? "([^"]*)"$/) do |name|
  copy File.join(aruba.config.fixtures_path_prefix, name), name
  cd name
end

Given(/^I copy (?:a|the) (file|directory)(?: (?:named|from))? "([^"]*)" to "([^"]*)"$/) do |file_or_directory, source, destination|
  copy source, destination
end

Given(/^I move (?:a|the) (file|directory)(?: (?:named|from))? "([^"]*)" to "([^"]*)"$/) do |file_or_directory, source, destination|
  move source, destination
end

Given(/^(?:a|the|(?:an empty)) directory(?: named)? "([^"]*)"$/) do |dir_name|
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
  write_file(file_name, unescape_text(file_content))
end

Given(/^(?:a|the) file(?: named)? "([^"]*)" with mode "([^"]*)" and with:$/) do |file_name, file_mode, file_content|
  write_file(file_name, unescape_text(file_content))
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

When(/^I write to "([^"]*)" with:$/) do |file_name, file_content|
  write_file(file_name, file_content)
end

When(/^I overwrite(?: (?:a|the) file(?: named)?)? "([^"]*)" with:$/) do |file_name, file_content|
  overwrite_file(file_name, file_content)
end

When(/^I append to "([^"]*)" with:$/) do |file_name, file_content|
  append_to_file(file_name, file_content)
end

When(/^I append to "([^"]*)" with "([^"]*)"$/) do |file_name, file_content|
  append_to_file(file_name, file_content)
end

When(/^I remove (?:a|the) (?:file|directory)(?: named)? "([^"]*)"( with full force)?$/) do |name, force_remove|
  remove(name, :force => force_remove.nil? ? false : true)
end

Given(/^(?:a|the) (?:file|directory)(?: named)? "([^"]*)" does not exist$/) do |name|
  remove(name, :force => true)
end

When(/^I cd to "([^"]*)"$/) do |dir|
  cd(dir)
end

Then(/^the following files should (not )?exist:$/) do |negated, files|
  files = files.rows.flatten

  if negated
    expect(files).not_to include an_existing_file
  else
    expect(files).to Aruba::Matchers.all be_an_existing_file
  end
end

Then(/^(?:a|the) (file|directory)(?: named)? "([^"]*)" should (not )?exist(?: anymore)?$/) do |directory_or_file, path, expect_match|
  if directory_or_file == 'file'
    if expect_match
      expect(path).not_to be_an_existing_file
    else
      expect(path).to be_an_existing_file
    end
  elsif directory_or_file == 'directory'
    if expect_match
      expect(path).not_to be_an_existing_directory
    else
      expect(path).to be_an_existing_directory
    end
  else
    fail ArgumentError, %("#{directory_or_file}" can only be "directory" or "file".)
  end
end

Then(/^(?:a|the) file matching %r<(.*?)> should (not )?exist$/) do |pattern, expect_match|
  if expect_match
    expect(all_paths).not_to include a_file_name_matching(pattern)
  else
    expect(all_paths).to include match a_file_name_matching(pattern)
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
    expect(directories).to Aruba::Matchers.all be_an_existing_directory
  end
end

Then(/^(?:a|the) file(?: named)? "([^"]*)" should (not )?contain "([^"]*)"$/) do |file, negated, content|
  if negated
    expect(file).not_to have_file_content file_content_including(content.chomp)
  else
    expect(file).to have_file_content file_content_including(content.chomp)
  end
end

Then(/^(?:a|the) file(?: named)? "([^"]*)" should (not )?contain:$/) do |file, negated, content|
  if negated
    expect(file).not_to have_file_content file_content_including(content.chomp)
  else
    expect(file).to have_file_content file_content_including(content.chomp)
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
    expect(file).not_to have_file_content file_content_matching(content)
  else
    expect(file).to have_file_content file_content_matching(content)
  end
end

Then(/^(?:a|the) file(?: named)? "([^"]*)" should (not )?match \/([^\/]*)\/$/) do |file, negated, content|
  if negated
    expect(file).not_to have_file_content file_content_matching(content)
  else
    expect(file).to have_file_content file_content_matching(content)
  end
end

Then(/^(?:a|the) file(?: named)? "([^"]*)" should (not )?be equal to file "([^"]*)"/) do |file, negated, reference_file|
  if negated
    expect(file).not_to have_same_file_content_as(reference_file)
  else
    expect(file).to have_same_file_content_as(reference_file)
  end
end

Then(/^the (?:file|directory)(?: named)? "([^"]*)" should( not)? have permissions "([^"]*)"$/) do |path, negated, permissions|
  if negated
    expect(path).not_to have_permissions(permissions)
  else
    expect(path).to have_permissions(permissions)
  end
end
