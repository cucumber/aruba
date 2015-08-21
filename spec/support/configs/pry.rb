# Otherwise pry doesn't find it's RC file
# if ENV['HOME'] is mocked
ENV['PRYRC'] = File.expand_path('~/.pryrc')
