CarrierWave.configure do |config|
  config.permissions = 0666
  config.directory_permissions = 0777
  config.storage = :file
  config.cache_dir = "#{Rails.root}/tmp/uploads"
end
