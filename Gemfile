source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

gem 'rails', '~> 6.1.7'
gem "redis-rails"

gem 'sqlite3', '~> 1.4'
gem 'puma', '~> 5.0'

gem 'bootsnap', '>= 1.4.4', require: false

# gem 'rack-cors'
#gem 'rack-attack'

gem "rack-attack", git: 'https://github.com/rack/rack-attack'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem "letter_opener"
end

group :development do
  gem 'listen', '~> 3.3'
  gem 'spring'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
