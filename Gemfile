source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby file: '.tool-versions'
gem 'rails', '8.1.1'

# global
# gem install bundler
# gem install foreman
# gem install debug

gem 'awesome_print', '1.9.2'
gem 'aws-sdk-s3', '1.203.1'
gem 'aws-sdk-sns', '1.108.0'
gem 'blazer', '3.3.0'
gem 'bootsnap', '1.18.6', require: false
gem 'caxlsx', '4.4.0'
gem 'caxlsx_rails', '0.6.4'
gem 'cssbundling-rails', '1.4.3'
gem 'csv', '3.3.5'
gem 'devise', '4.9.4'
gem 'faker', '3.5.2'
gem 'good_job', '4.12.1'
gem 'jbuilder', '2.14.1'
gem 'jsbundling-rails', '1.3.1'
gem 'kamal', '2.8.2', require: false
gem 'maintenance_tasks', '2.13.0'
gem 'pagy', '9.3.3' # 43.0.5 breaking changes
gem 'pg', '1.6.2'
gem 'pghero', '3.7.0', '>= 2'
gem 'pretender', '0.6.0'
gem 'propshaft', '1.3.1'
gem 'puma', '7.1.0'
gem 'pundit', '2.5.2'
gem 'ransack', '4.4.1'
gem 'roo', '3.0.0'
gem 'simple_form', '5.4.0'
gem 'solid_cache', '1.0.10'
gem 'stimulus-rails', '1.3.4'
gem 'thruster', '0.1.16', require: false
gem 'turbo-rails', '2.0.20'
gem 'tzinfo-data', '1.2025.2'
gem 'view_component', '4.1.1'

group :production, :staging do
  gem 'honeybadger', '6.1.3'
end

group :development, :test do
  gem 'debug', '1.11.0'
  gem 'factory_bot_rails', '6.5.1'
  gem 'rspec-rails', '8.0.2'
end

group :development do
  gem 'brakeman', '7.1.1', require: false
  gem 'bullet', '8.1.0'
  gem 'bundler-audit', '0.9.2', require: false
  gem 'lookbook', '2.3.13'
  gem 'rubocop', '1.81.7', require: false
  gem 'web-console', '4.2.1'
end

group :test do
  gem 'capybara', '3.40.0'
  gem 'database_cleaner-active_record', '2.2.2'
  gem 'rails-controller-testing', '1.0.5'
  gem 'rspec-github', '3.0.0', require: false
  gem 'rspec-instafail', '1.0.0', require: false
  gem 'rspec-json_expectations', '2.2.0'
  gem 'rspec_junit_formatter', '0.6.0'
  gem 'rspec-longrun', '3.1.0'
  gem 'selenium-webdriver', '4.38.0'
  gem 'shoulda-matchers', '7.0.1'
  gem 'timecop', '0.9.10'
end
