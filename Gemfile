source 'https://rubygems.org'

ruby '2.4.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.0', '>= 5.1.0'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.3.18', '< 0.5'
# Use Puma as the app server
gem 'puma'
# manages enviroment variables
gem 'dotenv-rails'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby
# Attachment/Image management
gem 'paperclip'
# style head start
gem 'bootstrap-sass'
# Form builder
gem 'formtastic'
# bootstrap friendly formtastic
gem 'formtastic-bootstrap'
# pagination
gem 'kaminari'
# http requests
gem 'httparty'
# allow cross origin rquests
gem 'rack-cors'
gem 'oauth'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster.
# Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 3.0'
gem 'redis-namespace'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
gem 'devise'

gem 'sidekiq'
gem 'sidekiq-throttler'
gem 'sidekiq-failures'

gem 'ruby-progressbar'
gem 'sentry-raven'

gem 'procodile'
gem 'highline'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'rubocop', require: false
end

group :test do
  gem 'minitest-rails'
  gem 'factory_girl'
  gem 'faker'
  gem 'webmock'
  gem 'vcr'
  gem 'm', '~> 1.5.0'
end

group :development do
  gem 'capistrano'
  gem 'capistrano-rvm'
  gem 'capistrano-rails'
  gem 'capistrano-rails-console', require: false

  # process monitor - not using until bugs are fixed
  # gem 'procodile-capistrano'
  #
  # use mine instead
  gem 'procodile-capistrano', github: 'nestorw/procodile-capistrano'

  gem 'rack-mini-profiler'
  gem 'web-console'
  gem 'listen'
  # Spring speeds up development by keeping your application running in the background.
  # Read more: https://github.com/rails/spring
  # gem 'spring'
  # gem 'spring-watcher-listen', '~> 2.0.0'

end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
