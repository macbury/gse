# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'capybara/email/rspec'
require 'factory_girl_rails'
require 'webmock/rspec'
require 'vcr'
require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
end

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, {
    js_errors: true,
    window_size: [1920, 1080],
    phantomjs_logger: Rails.logger,
    inspector: true
  })
end

Capybara.javascript_driver = :poltergeist
Capybara.default_driver    = :poltergeist

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :active_record
    with.library :rails
  end
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.order = 'random'

  config.before(:suite) do
    WebpackSupport.start! if ENV['CI']
    ScreenshotSupport.clean!
  end

  config.after(:suite) do
    WebpackSupport.stop!
  end

  config.around(:each) do |example|
    ActionMailer::Base.deliveries.clear
    example.run
  end

  config.after(:each) do |example|
    if example.metadata[:type] == :feature
      if example.exception.present?
        ScreenshotSupport.failure!(page, example)
      else
        ScreenshotSupport.success!(page, example)
      end
    end
  end

  config.around(:each) do |example|
    name = example.metadata[:vcr]
    if name.blank?
      example.call
    else
      VCR.use_cassette(name) { example.call }
    end
  end

  config.before(:each) do |example|
    DatabaseCleaner.clean
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
    if example.metadata[:type] == :feature
      clear_emails
    end
  end
end
