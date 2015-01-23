require 'simplecov'
SimpleCov.start 'rails'

ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"
require "minitest/rails/capybara"
require "minitest/pride"
require "database_cleaner"
require "minitest/reporters"

Dir[Rails.root.join("test/support/**/*.rb")].each { |f| require f }

# Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new(color: true)
Minitest::Reporters.use! Minitest::Reporters::RubyMineReporter.new(color: true)

DatabaseCleaner.strategy = :transaction

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
  ActiveRecord::Migration.check_pending!

  fixtures :all

  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end

end

class ActionController::TestCase
  include Devise::TestHelpers
end

class MiniTest::Spec
  include FactoryGirl::Syntax::Methods

  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end
end

