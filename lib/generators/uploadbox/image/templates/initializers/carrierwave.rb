if Rails.env.production?
  CarrierWave.configure do |config|
    config.storage = :fog

    config.fog_credentials = {
      provider:               'AWS',
      aws_access_key_id:      ENV['S3_KEY'],
      aws_secret_access_key:  ENV['S3_SECRET'],
      region:                 ENV['S3_REGION']
    }

    config.fog_directory  = ENV['S3_BUCKET']
    config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}
  end
end

if Rails.env.test?
  CarrierWave.configure do |config|
    config.storage :file
    config.enable_processing = false
  end
end
