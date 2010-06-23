# Load the rails application
require File.expand_path('../application', __FILE__)
require Rails.root + 'lib/core_extensions/array'

# Initialize the rails application
WeVote::Application.initialize!
