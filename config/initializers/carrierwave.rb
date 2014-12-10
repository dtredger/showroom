CarrierWave.configure do |config|

  if Rails.env.test? || ENV['RAILS_OFFLINE'] == 'true'
    config.storage = :file
    config.enable_processing = false
    config.base_path = ""
  else
    config.storage = :aws
  end

  config.aws_bucket = ENV['AWS_BUCKETNAME']
  config.aws_acl = :public_read
  config.aws_credentials = {
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
  }

end

