source 'https://rubygems.org'

gemspec

group :development, :test do
end

group :debug do
  gem 'pry', '~> 0.10.1'

  platform :mri_20 do
    gem 'byebug', '~> 4.0.5'
    gem 'pry-byebug', '~> 3.1.0'
  end

  gem 'pry-stack_explorer', '~> 0.4.9'
  gem 'pry-doc', '~> 0.8.0'
end

group :development, :test do
  gem 'bcat', '~> 0.6.2'
  gem 'kramdown', '~> 1.7.0'

  gem 'simplecov', '~> 0.10'
  gem 'rake', '~> 10.4.2'
  gem 'rspec', '~> 3.3.0'
  gem 'fuubar', '~> 2.0.0'
  gem 'cucumber-pro', '~> 0.0'
  gem 'rubocop', '~> 0.32.0'

  gem 'license_finder', '~> 2.0.4'

  gem 'relish', '~> 0.7.1'
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
