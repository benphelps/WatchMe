CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => 'AKIAISLFYNZLIOEZROFA',
    :aws_secret_access_key  => '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',
    :path_style            => true
  }
  config.fog_directory  = 'watchme.io'
  config.fog_public     = false
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}
end