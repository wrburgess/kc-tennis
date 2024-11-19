class AwsSnsService
  def self.confirm(arn, token)
    client = retrieve_client
    client.confirm_subscription(topic_arn: arn, token: token)
  end

  def self.retrieve_client
    creds = Aws::Credentials.new(
      Rails.application.credentials.dig(:aws, :access_key_id),
      Rails.application.credentials.dig(:aws, :secret_access_key)
    )
    Aws::SNS::Client.new(region: AwsRegionTypes::US_EAST_1, credentials: creds)
  end
end
