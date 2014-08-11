AssetSync.configure do |config|
  config.fog_provider = 'AWS'
  config.aws_access_key_id = Settings.aws.key
  config.aws_secret_access_key = Settings.aws.secret
  config.fog_directory = Settings.aws.bucket
  config.manifest = true
  config.existing_remote_files = 'delete'
  #config.gzip_compression = true
end
