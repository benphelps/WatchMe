CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => 'AKIAISLFYNZLIOEZROFA',
    :aws_secret_access_key  => '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',
  }
  config.fog_directory  = Settings.s3.bucket
  config.fog_public     = true
  config.fog_attributes = {
    :public => true,
    :metadata => {
      'Cache-Control' => 'max-age=315576000'
    }
  }
end