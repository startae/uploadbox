Uploadbox.retina         = true
Uploadbox.retina_quality = 30
Uploadbox.image_quality  = 70

if Rails.env.production?
  Uploadbox.background_processing  = true

  REDIS = Redis.connect(url: ENV["REDISCLOUD_URL"])
  Resque.redis = REDIS
  Resque.after_fork = Proc.new { ActiveRecord::Base.establish_connection }
end

if Rails.env.development?
  Uploadbox.resque_server = true
end

CarrierWave.configure do |config|
  config.storage = :fog

  config.fog_credentials = {
    provider:               'AWS',
    aws_access_key_id:      ENV['S3_KEY'],
    aws_secret_access_key:  ENV['S3_SECRET']
  }

  config.fog_directory  = ENV['S3_BUCKET']
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}
end

if Rails.env.test?
  CarrierWave.configure do |config|
    config.storage :file
    config.enable_processing = false
  end
end
