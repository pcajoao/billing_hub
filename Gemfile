source "https://rubygems.org"

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.0"

# Use sqlite3 as the database for Active Record
gem "sqlite3", "~> 1.4"

group :production do
  gem "pg", "~> 1.1"
end

# Use Puma as the app server
gem "puma", "~> 6.0"

# Use Redis adapter to run Action Cable in production
gem "redis", ">= 4.0"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Paranoia/Soft Delete
gem "discard", "~> 1.2"

# Money handling
gem "money-rails"

# State Machine for Invoice status
gem "state_machines-activerecord"

# Payment Gateway SDK
gem "pagarme"

# Background Jobs
gem "sidekiq"

# Service Objects Pattern
gem "simple_command"

# Multi-tenancy
gem "ros-apartment", require: "apartment"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "database_cleaner-active_record"
end

group :development do
  # Listen to file changes and automatically clear caches
  gem "listen", "~> 3.3"

  # Spring speeds up development by keeping your application running in the background
  gem "spring"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
