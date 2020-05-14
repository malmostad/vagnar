source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.4'
# Use sqlite3 as the database for Active Record
# gem 'sqlite3'
gem 'mysql2', '~> 0.4.10'
gem 'dalli', '~> 2.7.6'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0.7'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 3.2.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'execjs'
gem 'therubyracer', '~> 0.12.3', platforms: :ruby

gem 'pry-rails'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
# gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.11'

gem 'simple_form', '~> 4.1.0'
gem 'haml-rails', '~> 1.0.0'

gem 'net-ldap', '~> 0.16.1'
gem 'ruby-saml', '~> 1.6.0'

gem 'axlsx', git: 'https://github.com/randym/axlsx.git', ref: '05f3412'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  gem 'puma'

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver

  gem 'rspec-rails'

  gem 'rails-controller-testing'
  gem 'factory_bot_rails', '~>  5.2.0'
  gem 'capybara', '~> 2.15'
  # gem 'capybara-webkit'
  # gem 'poltergeist'
  gem 'selenium-webdriver'
end

group :development do
  gem 'listen'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem 'spring'
  # gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'

  gem 'bullet'
end

group :production do
  gem 'unicorn', '~> 5.3.1'
end
