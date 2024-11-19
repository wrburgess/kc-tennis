class AwsS3Service
  def self.retrieve_client
    creds = Aws::Credentials.new(
      Rails.application.credentials.dig(:aws, :access_key_id),
      Rails.application.credentials.dig(:aws, :secret_access_key)
    )
    Aws::S3::Client.new(region: AwsRegionTypes::US_EAST_1, credentials: creds)
  end
end
