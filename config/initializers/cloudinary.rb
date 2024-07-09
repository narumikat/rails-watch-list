# # config/initializers/cloudinary.rb

# if ENV['CLOUDINARY_URL']
#   begin
#     cloudinary_url = ENV['CLOUDINARY_URL']
#     match = cloudinary_url.match(%r{cloudinary://(?<api_key>[^:]+):(?<api_secret>[^@]+)@(?<cloud_name>.+)})
#     if match
#       Rails.application.config.secure_distribution = match[:cloud_name]
#       puts "secure_distribution: #{Rails.application.config.secure_distribution}" # Debugging line
#     else
#       raise "Invalid CLOUDINARY_URL format"
#     end
#   rescue => e
#     raise "Error parsing CLOUDINARY_URL environment variable: #{e.message}"
#   end
# else
#   raise "CLOUDINARY_URL environment variable is not set"
# end
