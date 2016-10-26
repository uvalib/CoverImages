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
    config.filter_sensitive_data('<API_KEY>') { ENV['LAST_FM_KEY'] }
    config.filter_sensitive_data('<API_KEY>') { ENV['LIBRARY_THING_KEY'] }
    config.filter_sensitive_data('<USER_AGENT>') { ENV['EXTERNAL_API_USER_AGENT'] }
  end

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all

  # Add more helper methods to be used by all tests here...
  #

end
