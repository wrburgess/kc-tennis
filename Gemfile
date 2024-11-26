source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby file: '.tool-versions'
gem 'rails', '8.0.0'

# global
# gem install bundler
# gem install foreman
# gem install debug

gem 'aws-sdk-s3', '1.174.0'
gem 'aws-sdk-sns', '1.92.0'
gem 'bootsnap', '1.18.4', require: false
gem 'caxlsx', '4.1.0'
gem 'caxlsx_rails', '0.6.4'
gem 'csv', '3.3.0'
gem 'devise', '4.9.4'
gem 'good_job', '4.5.0'
gem 'jbuilder', '2.13.0'
gem 'jsbundling-rails', '1.3.1'
gem 'kamal', '2.3.0', require: false
gem 'maintenance_tasks', '2.9.0'
gem 'pagy', '9.3.1'
gem 'pg', '1.5.9'
gem 'propshaft', '1.1.0'
gem 'puma', '6.5.0'
gem 'pundit', '2.4.0'
gem 'ransack', '4.2.1'
gem 'roo', '2.10.1'
gem 'solid_cable', '3.0.2'
gem 'solid_cache', '1.0.6'
gem 'stimulus-rails', '1.3.4'
gem 'thruster', '0.1.9', require: false
gem 'turbo-rails', '2.0.11'
gem 'tzinfo-data', '1.2024.2'
gem 'view_component', '3.20.0'

group :production, :staging do
  gem 'honeybadger', '5.25.0'
end

group :development, :test do
  gem 'debug', '1.9.2'
end

group :development do
  gem 'brakeman', '6.2.2', require: false
  gem 'bullet', '8.0.0'
  gem 'bundler-audit', '0.9.2', require: false
  gem 'hakiri', '0.7.2', require: false
  gem 'lookbook', '2.3.4'
  gem 'rspec-rails', '7.1.0'
  gem 'rubocop', '1.69.0', require: false
  gem 'web-console', '4.2.1'
end

group :test do
  gem 'capybara', '3.40.0'
  gem 'database_cleaner-active_record', '2.2.0'
  gem 'factory_bot_rails', '6.4.4'
  gem 'faker', '3.5.1'
  gem 'rails-controller-testing', '1.0.5'
  gem 'rspec-github', '2.4.0', require: false
  gem 'rspec-instafail', '1.0.0', require: false
  gem 'rspec-json_expectations', '2.2.0'
  gem 'rspec_junit_formatter', '0.6.0'
  gem 'rspec-longrun', '3.1.0'
  gem 'selenium-webdriver', '4.27.0'
  gem 'shoulda-matchers', '6.4.0'
end
