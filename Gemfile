source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.1'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
gem 'jquery-turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

##### add
gem 'haml-rails'
gem 'anemone' # web crawler
gem 'nokogiri'
gem 'faraday' # http client

gem 'twitter-bootstrap-rails'
gem 'twitter-bootswatch-rails'
gem 'twitter-bootswatch-rails-helpers'
gem 'therubyracer'

# Calendar
gem 'fullcalendar-rails'
gem 'momentjs-rails'

# twitter
gem 'twitter'

group :development, :test do
  gem 'sqlite3'
  gem 'pry-byebug'
  gem 'guard-livereload'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

# prod
group :production do
  gem 'mysql'
  gem 'mysql2', '~> 0.3.20',  group: :production
end

group :heroku do
  gem 'pg'
end
end
