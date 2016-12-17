source 'https://rubygems.org'

ruby '2.2.6'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.1'
# Use mysql as the database for Active Record
gem 'mysql2'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', :platforms => :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', :group => :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'
gem 'puma'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'bootstrap-sass'
gem 'haml-rails'
gem 'kramdown'
gem 'simple_calendar'
gem 'decent_exposure'
gem 'rails-i18n'

gem 'listings', :git => 'https://github.com/manastech/listings.git', :branch => 'master'

# gem 'rails_12factor', :group => :production
gem 'devise'
gem 'devise-bootstrap-views'
gem 'simple_form'
gem 'config'
gem 'rest-client'
gem 'newrelic_rpm'
gem 'bootstrap3_autocomplete_input'
gem 'bootstrap-datepicker-rails'
gem 'react-rails'
gem 'lodash-rails'
gem 'kaminari'

source 'https://rails-assets.org' do
  gem 'rails-assets-urijs'
  gem 'rails-assets-classnames'
  gem 'rails-assets-q', '~> 1.0'
  gem 'rails-assets-sass-flex-mixin'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 1.3.6'

  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'timecop'

  gem 'site_prism'
  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'poltergeist'
  gem 'selenium-webdriver'
  gem 'database_cleaner'
end

group :development do
  gem 'better_errors'

  gem 'capistrano',         require: false
  gem 'capistrano-rbenv',   require: false
  gem 'capistrano-rails',   require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano3-puma',   require: false
end
