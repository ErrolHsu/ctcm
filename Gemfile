source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.4.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.2.0'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
# gem 'coffee-rails', '~> 4.2'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
gem 'capistrano-rails', group: :development
gem 'capistrano-passenger', :group => :development
gem 'capistrano-sidekiq', group: :development

# gem 'vuejs-rails'

gem 'bootstrap', '~> 4.1.2'

gem 'jquery-rails'

# gem 'font-awesome-sass', '~> 5.0.13'

gem 'devise'

gem 'awesome_print'

gem 'decent_exposure', '3.0.0'

gem 'active_hash'

gem 'haml'
# fb sign up or login
# gem 'omniauth'
# gem 'omniauth-facebook'
# gem 'koala'

# img size
gem 'image_processing', '~> 1.2'

# 管理各種設定
gem 'settingslogic'

# http request
gem 'faraday'
gem 'rest-client'

gem 'webpacker'

# mailgun
gem 'mailgun-ruby', '~>1.1.6'

#jwt
gem 'jwt'

# 多國語系
gem "rails-i18n"

# for 正式機node 版本bug
gem 'mini_racer'

gem 'sidekiq'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'faker'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'foreman'
  # 郵件預覽
  gem "letter_opener"
end

group :production do
  gem "google-cloud-storage", "~> 1.8"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
