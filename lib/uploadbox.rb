require "uploadbox/engine"

module Uploadbox
  mattr_accessor :retina
  mattr_accessor :image_quality
  mattr_accessor :retina_quality
  mattr_accessor :background_processing
  mattr_accessor :resque_server
end
