module ApplicationHelper
  def policy
    Base64.encode64(policy_data.to_json).gsub("\n", "")
  end

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

  def signature
    Base64.encode64(
      OpenSSL::HMAC.digest(
        OpenSSL::Digest::Digest.new('sha1'),
        ENV['S3_SECRET'],
        policy
      )
    ).gsub("\n", "")
  end
end
