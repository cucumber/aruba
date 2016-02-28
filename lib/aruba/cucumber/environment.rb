Given(/^a mocked home directory$/)do
  set_environment_variable 'HOME', expand_path('.')
end

Given(/^I set the environment variable "(.*)" to "(.*)"/) do |variable, value|
  set_environment_variable(variable.to_s, value.to_s)
end

Given(/^I append "(.*)" to the environment variable "(.*)"/) do |value, variable|
  append_environment_variable(variable.to_s, value.to_s)
end

Given(/^I prepend "(.*)" to the environment variable "(.*)"/) do |value, variable|
  prepend_environment_variable(variable.to_s, value.to_s)
end

Given(/^I set the environment variables? to:/) do |table|
  table.hashes.each do |row|
    variable = row['variable'].to_s
    value = row['value'].to_s

    set_environment_variable(variable, value)
  end
end

Given(/^I append the values? to the environment variables?:/) do |table|
  table.hashes.each do |row|
    variable = row['variable'].to_s
    value = row['value'].to_s

    append_environment_variable(variable, value)
  end
end

Given(/^I prepend the values? to the environment variables?:/) do |table|
  table.hashes.each do |row|
    variable = row['variable'].to_s
    value = row['value'].to_s

    prepend_environment_variable(variable, value)
  end
end
