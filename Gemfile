source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.3.4'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
gem 'bcrypt', '~> 3.1.7'
gem 'devise'
gem 'pundit'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'
# Front end asset manager
source 'https://rails-assets.org' do
  gem 'rails-assets-bootstrap', '~> 3.3.7'
  gem 'rails-assets-bootstrap-select', '~>1.12.0'
  gem 'rails-assets-bootstrap-toggle'
  gem 'rails-assets-jquery-ui', '~> 1.12'
  gem 'rails-assets-blueimp-file-upload', '~> 9.14.1'
  gem 'rails-assets-bootstrap3-datetimepicker'
  gem 'rails-assets-jasny-bootstrap', '~> 3.1.3'
  gem 'rails-assets-bootstrap-dialog'
  gem 'rails-assets-moment'
  gem 'rails-assets-moment-timezone'
end

# Font awesome icons
gem 'font-awesome-sass', '~> 5.11', '>= 5.11.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

gem 'jbuilder', '~> 2.5'


# date manipulator required for full calendar
gem 'momentjs-rails', '~> 2.17', '>= 2.17.1'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'rspec-rails'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'jquery-datatables-rails'
gem 'paper_trail'
