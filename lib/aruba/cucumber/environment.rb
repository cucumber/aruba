Given(/^a mocked home directory$/)do
  set_environment_variable 'HOME', expand_path('.')
end

Given(/^I set the environment variables? to:/) do |table|
  table.hashes.each do |row|
    variable = row['variable'].to_s.upcase
    value = row['value'].to_s

    set_environment_variable(variable, value)
  end
end

Given(/^I append the values? to the environment variables?:/) do |table|
  table.hashes.each do |row|
    variable = row['variable'].to_s.upcase
    value = row['value'].to_s

    append_environment_variable(variable, value)
  end
end

Given(/^I prepend the values? to the environment variables?:/) do |table|
  table.hashes.each do |row|
    variable = row['variable'].to_s.upcase
    value = row['value'].to_s

    prepend_environment_variable(variable, value)
  end
end
