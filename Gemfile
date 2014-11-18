source 'https://rubygems.org'
ruby '2.1.1'

gem 'bootstrap-sass', '3.1.1.1'
gem 'rails', '4.1.1'
gem 'haml-rails'
gem 'jquery-rails'
gem 'bootstrap_form'
gem 'bcrypt'
gem 'fabrication'
gem 'faker'
gem 'autoprefixer-rails'

group :assets do 
gem 'sass-rails'
gem 'coffee-rails'
gem 'uglifier'
end 
group :development do
  gem 'sqlite3'
  gem 'thin'
  gem "better_errors"
  gem "binding_of_caller"
end

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails', '2.99'
end

group :test do
  gem 'database_cleaner', '1.2.0'
  gem 'shoulda-matchers'
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
end