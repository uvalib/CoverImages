ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'sidekiq/testing'
require 'webmock/minitest'
require 'vcr'

class ActiveSupport::TestCase

  include FactoryGirl::Syntax::Methods
  FactoryGirl.find_definitions

  VCR.configure do |config|
    config.cassette_library_dir = "test/fixtures/vcr_cassettes"
    config.hook_into :webmock
  end

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #fixtures :all


  # Add more helper methods to be used by all tests here...
  #


end
