Uploadbox.retina         = true
Uploadbox.retina_quality = 30
Uploadbox.image_quality  = 70

if Rails.env.test?
  CarrierWave.configure do |config|
    config.storage :file
    config.enable_processing = false
  end
end
