module Uploadbox
  module ImgHelper
    def s3_policy
      Base64.encode64(policy_data.to_json).gsub("\n", "")
    end


    def s3_signature
      Base64.encode64(
        OpenSSL::HMAC.digest(
          OpenSSL::Digest::Digest.new('sha1'),
          ENV['S3_SECRET'],
          s3_policy
        )
      ).gsub("\n", "")
    end

    def img(*args)
      upload = args[0]
      if upload.is_a? CarrierWave::Uploader::Base
        image_tag(upload.url, width: upload.width, height: upload.height)
      else
        image_tag(*args)
      end
    end

    private
      def policy_data
        {
          expiration: 10.hours.from_now.utc.iso8601,
          conditions: [
            ["starts-with", "$key", 'uploads/'],
            ["content-length-range", 0, 500.megabytes],
            ["starts-with","$content-type",""],
            {bucket: ENV['S3_BUCKET']},
            {acl: 'public-read'}
          ]
        }
      end
  end
end
