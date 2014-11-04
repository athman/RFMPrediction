require 'dragonfly'
require 'dragonfly/s3_data_store'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  secret "1a39431cc1754765bb089c3a23780a181d16363f880469ad69a54ef4e2087a6d"

  url_format "/media/:job/:name"

  datastore :file,
    root_path: Rails.root.join('public/system/dragonfly', Rails.env),
    server_root: Rails.root.join('public')
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




app = Dragonfly.app

app.configure_with(:imagemagick)
app.configure_with(:rails)
if Rails.env.production?
  app.configure do |c|
    c.datastore = Dragonfly::DataStorage::S3DataStore.new(
      :bucket_name => 'rfmprediction-datasets',
      :access_key_id => ENV['S3_KEY'],
      :secret_access_key => ENV['S3_SECRET']
    )
  end
end

app.define_macro(ActiveRecord::Base, :dataset_accessor)




# Configuration for Amazon s3
# url_format "/media/:job/:name"
if Rails.env.development? || Rails.env.test?
    datastore :file,
        root_path: Rails.root.join('public/system/dragonfly', Rails.env),
        server_root: Rails.root.join('public')
end

#else
#    datastore :s3,
#        bucket_name: "rfmprediction-datasets",
#        access_key_id: "AKIAJU6P5VS4ZJYKVS2A",
#        secret_access_key: "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",
#        url_scheme: 'https'
#end
