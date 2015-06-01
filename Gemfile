source 'https://rubygems.org'

gemspec

group :development, :test do
  gem 'simplecov'
end

group :debug do
  gem 'pry', '~> 0.10.1 '
  gem 'byebug', '~> 4.0.5'
  gem 'pry-byebug', '~> 3.1.0'
  gem 'pry-stack_explorer', '~> 0.4.9'
  gem 'pry-doc', '~> 0.6.0'
end

group :development, :test do
  gem 'bcat', '>= 0.6.1'
  gem 'kramdown', '>= 0.14'
  gem 'rake', '>= 0.9.2'
  gem 'rspec', '>= 3.0.0'
  gem 'fuubar', '>= 1.1.1'
  gem 'cucumber-pro', '~> 0.0'
  gem 'rubocop', '~> 0.31.0'

  gem 'license_finder', '~> 2.0.4'

  gem 'relish'
end

platforms :rbx do
  gem 'rubysl', '~> 2.0'
  gem 'rubinius-developer_tools'
end

# Use source from sibling folders (if available) instead of gems
# %w[cucumber].each do |g|
#   if File.directory?(File.dirname(__FILE__) + "/../#{g}")
#     @dependencies.reject!{|dep| dep.name == g}
#     gem g, :path => "../#{g}"
#   end
# end
