# Load the Rails application.
require_relative 'application'

# Print the CLOUDINARY_URL to check if it's being loaded
puts "CLOUDINARY_URL: #{ENV['CLOUDINARY_URL']}"

# Initialize the Rails application.
Rails.application.initialize!
