module StorageAssetService
  module Azure
    class GenerateTemporaryUrl
      def initialize(storage_asset)
        @storage_asset = storage_asset
      end

      def call
        storage_account_name = Rails.application.credentials.dig(:storage_assets, :azure, :storage_account_name)
        storage_account_key =  Rails.application.credentials.dig(:storage_assets, :azure, :storage_account_key)

        permissions = 'r' # Read permissions only
        resource = 'b' # Blob resource type
        api_version = '2024-11-04' # Azure API version to use

        start = Time.current.utc.iso8601
        expiry = 1.day.from_now.utc.iso8601
        canonicalized_resource = "/blob/#{storage_account_name}#{@storage_asset.full_path}"

        # All of these newlines are required by Azure even if they are empty, so don't remove them.
        # Documentation of all the the parameters used to generate the signature:
        # https://learn.microsoft.com/en-us/rest/api/storageservices/create-service-sas
        string_to_sign = permissions + "\n" +
                         start + "\n" +
                         expiry + "\n" +
                         canonicalized_resource + "\n" +
                         "\n" +
                         "\n" +
                         "\n" +
                         api_version + "\n" +
                         resource + "\n" +
                         "\n" +
                         "\n" +
                         "\n" +
                         "\n" +
                         "\n" +
                         "\n"

        signature = Base64.strict_encode64(OpenSSL::HMAC.digest('sha256', Base64.decode64(storage_account_key), string_to_sign))
        encoded_signature = CGI.escape(signature)

        {
          url: "https://#{storage_account_name}.blob.core.windows.net#{@storage_asset.full_path}?sp=#{permissions}&st=#{start}&se=#{expiry}&sv=#{api_version}&sr=#{resource}&sig=#{encoded_signature}",
          expires_at: Time.parse(expiry)
        }
      end
    end
  end
end
