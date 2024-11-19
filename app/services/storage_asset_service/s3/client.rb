module StorageAssetService
  module S3
    class Client
      def call
        access_key_id = Rails.application.credentials.dig(:storage_assets, :s3, :access_key_id)
        secret_access_key = Rails.application.credentials.dig(:storage_assets, :s3, :secret_access_key)
        region = Rails.application.credentials.dig(:storage_assets, :s3, :region)

        credentials = Aws::Credentials.new(access_key_id, secret_access_key)
        Aws::S3::Client.new(region:, credentials:)
      end
    end
  end
end
