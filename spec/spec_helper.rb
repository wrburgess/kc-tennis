RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.example_status_persistence_file_path = 'spec/examples.txt'

  config.default_formatter = 'doc' if config.files_to_run.one?

  config.order = :random
  Kernel.srand config.seed

  config.before(:each) do |example|
    DatabaseCleaner.start unless example.metadata[:skip_db_cleaner]
  end

  config.append_after(:each) do |example|
    DatabaseCleaner.clean unless example.metadata[:skip_db_cleaner]
  end

  # TODO: Remove below adjustments when Devise fixes https://github.com/heartcombo/devise/issues/5705
  config.before(:each, type: :controller) do
    Rails.application.reload_routes_unless_loaded
  end

  config.before(:each, type: :component) do
    Rails.application.reload_routes_unless_loaded
  end
end
