CarrierWave.configure do |config|

  if Rails.env.test?
    config.storage = :file
    config.enable_processing = false
    config.root = "#{Rails.root}/tmp"
  else
    config.storage = :aws
  end

  config.aws_bucket = ENV['AWS_BUCKETNAME']
  # config.asset_host = ENV['AWS_ENDPOINT'] #not needed
  config.aws_acl = :public_read
  config.aws_credentials = {
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
  }

end

