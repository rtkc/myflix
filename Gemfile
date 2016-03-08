source 'https://rubygems.org'
ruby '2.1.2'

gem 'bootstrap-sass'
gem 'coffee-rails'
gem 'rails', '4.1.1'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'pg'
gem 'bootstrap_form'
gem 'bcrypt'
gem 'fabrication'
gem 'faker'
gem 'sidekiq'
gem 'puma'
gem "sentry-raven"

group :development do
  gem 'thin'
  gem "better_errors"
  gem "binding_of_caller"
  gem 'shoulda-matchers', '2.7.0', require: false
  gem 'letter_opener'
end

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails', '2.99'
end

group :test do
  gem 'database_cleaner', '1.4.1'
  gem 'capybara'
  gem 'capybara-email'
end

group :production do
  gem 'rails_12factor'
end