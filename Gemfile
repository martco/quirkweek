source 'http://rubygems.org'

gem 'rails', '3.1.1'
gem 'thin'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'pg'
gem 'haml'
gem 'omniauth-twitter'
gem 'omniauth-facebook'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.1.4'
  gem 'coffee-rails', '~> 3.1.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
end

group :test, :development do
  gem 'sqlite3'
  gem 'annotate', :git => 'git://github.com/ctran/annotate_models.git'
end