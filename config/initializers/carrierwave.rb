require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

CarrierWave.configure do |config|
  config.fog_credentials = {
    provider:              'AWS',
    aws_access_key_id:     Rails.application.secrets.aws_access_key_id,
    aws_secret_access_key: Rails.application.secrets.aws_secret_access_key,
    region: "us-west-1"
  }

  if Rails.env.staging? || Rails.env.production?
    config.storage = :fog
  else
    config.storage = :file
    config.enable_processing = false
    config.root = "#{Rails.root}/tmp"
  end

  config.cache_dir = "#{Rails.root}/tmp/uploads" 
  config.fog_directory    = ENV['S3_BUCKET_NAME']
end
