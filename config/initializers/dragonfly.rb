require 'dragonfly'
require 'dragonfly/s3_data_store'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  secret "1a39431cc1754765bb089c3a23780a181d16363f880469ad69a54ef4e2087a6d"

  url_format "/media/:job/:name"


    if Rails.env.development? || Rails.env.test?
        datastore :file,
            root_path: Rails.root.join('public/system/dragonfly', Rails.env),
            server_root: Rails.root.join('public')
    else
        datastore :s3,
            bucket_name: ENV['S3_BUCKET_NAME'],
            access_key_id: ENV['AWS_ACCESS_KEY_ID'],
            secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
            url_scheme: 'https'
    end
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware

# Add model functionality
if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend Dragonfly::Model
  ActiveRecord::Base.extend Dragonfly::Model::Validations
end
