# Load the rails application
require File.expand_path('../application', __FILE__)

# Load OAuth settings
oauth_environment_variables = File.join(Rails.root, 'config', 'oauth_environment_variables.rb')
load(oauth_environment_variables) if File.exist?(oauth_environment_variables)

# Initialize the rails application
Graph3::Application.initialize!
