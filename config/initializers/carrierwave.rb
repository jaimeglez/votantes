require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

CarrierWave.configure do |config|
  config.fog_credentials = {
    provider:              'AWS',
    aws_access_key_id:     ENV["AWS_VOTERS_ACCESS_KEY"],
    aws_secret_access_key: ENV["AWS_VOTERS_SECRET_KEY"],
    region: "us-west-2"
  }
  config.fog_directory  = 'we-send-it'
  config.fog_attributes = { 'Cache-Control' => "max-age=#{365.day.to_i}" } # optional, defaults to {}
end
