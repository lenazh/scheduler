source 'https://rubygems.org'

ruby '2.1.5'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Secure configuration
gem 'figaro'

# Puma webserver
gem 'puma'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc


# Use Slim for views
gem 'slim-rails'

# Use AngularJS for the frontend
gem 'angularjs-rails'

# Authentication and authorization
gem 'devise'
gem 'omniauth-google-oauth2'
gem 'pundit'

# Use twitter bootstrap CSS
gem 'twitter-bootstrap-rails'

# Use gon to supply JS variables from the controller
gem 'gon'

group :development do
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring',        group: :development
  # Ruby lint
  gem 'rubocop', require: false
  # CoffeeScript lint
  gem 'coffeelint'
end

group :development, :test do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'
  gem 'binding_of_caller', '~> 0.7.2'
  gem 'pry'
  gem 'pry-byebug'
  gem 'jasmine'
  gem 'jasmine-rails'
  gem 'rspec-rails', '~> 2.14.1'
  gem 'rspec-core'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'capybara-angular'
  gem 'poltergeist'
  gem 'autotest-rails'
end

group :test do
  gem 'cucumber-rails', :require => false
  gem 'cucumber-rails-training-wheels'
end

# code coverage code climate
gem 'codeclimate-test-reporter', group: :test

group :production do
  # Use Postgres as the database for Active Record
  gem 'pg'
  gem 'rails_12factor'
  gem 'heroku-deflater'
end