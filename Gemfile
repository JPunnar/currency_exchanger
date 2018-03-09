# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'cancancan', '~> 2.0'
gem 'chartkick', '~> 2.3', '>= 2.3.2'
gem "autoprefixer-rails"
gem "bootstrap", "~> 4.0.0"
gem "devise"
gem "font-awesome-rails"
gem "httparty"
gem "jquery-rails", "~> 4.3", ">= 4.3.1"
gem "pg"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 5.1.5"
# Use Puma as the app server
gem "puma", "~> 3.7"
# Use SCSS for stylesheets
gem "sass-rails", "~> 5.0"
# Use Uglifier as compressor for JavaScript assets
gem "uglifier", ">= 1.3.0"

# Use CoffeeScript for .coffee assets and views
gem "coffee-rails", "~> 4.2"
gem "turbolinks", "~> 5"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.5"

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", "~> 2.13"
  gem "pry", "~> 0.11.3"
  gem "selenium-webdriver"
end

group :development do
  gem "rubocop-rails"
  gem "annotate"
  gem "better_errors"
  gem "binding_of_caller"
  gem "rubocop", require: false
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "web-console", ">= 3.3.0"
  # Spring speeds up development by keeping your application running in the background.
  # Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

ruby "2.4.1"
