# Load the rails application
require File.expand_path('../application', __FILE__)
require Rails.root + 'lib/core_extensions/array'
# 
# ActionMailer::Base.smtp_settings = {
#   :tls => "true",
#   :address => "smtp.gmail.com",
#   :port => 587,
#   :authentication => :plain,
#   :domain => ENV['GMAIL_SMTP_USER'],
#   :user_name => ENV['GMAIL_SMTP_USER'],
#   :password => ENV['GMAIL_SMTP_PASSWORD'],
# }

# Initialize the rails application
WeVote::Application.initialize!
