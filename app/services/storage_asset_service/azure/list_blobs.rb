module StorageAssetService
  module Azure
    class ListBlobs
      def initialize(storage_container: nil)
        @storage_container = storage_container
      end

      def call
        storage_account_name = Rails.application.credentials.dig(:storage_assets, :azure, :storage_account_name)
        storage_account_key =  Rails.application.credentials.dig(:storage_assets, :azure, :storage_account_key)
        api_version = '2024-11-04'
        timestamp = Time.now.utc.strftime('%a, %d %b %Y %H:%M:%S GMT')

        # All of these newlines are required by Azure even if they are empty, so don't remove them.
        # Documentation of all the the parameters used to generate the signature:
        # https://learn.microsoft.com/en-us/rest/api/storageservices/authorize-with-shared-key

        # rubocop:disable Style/StringConcatenation
        string_to_sign = "GET\n" +                                            # HTTP method
                         "\n" +                                               # Content-Encoding
                         "\n" +                                               # Content-Language
                         "\n" +                                               # Content-Length
                         "\n" +                                               # Content-MD5
                         "\n" +                                               # Content-Type
                         "\n" +                                               # Date
                         "\n" +                                               # If-Modified-Since
                         "\n" +                                               # If-Match
                         "\n" +                                               # If-None-Match
                         "\n" +                                               # If-Unmodified-Since
                         "\n" +                                               # Range
                         "x-ms-date:#{timestamp}\n" +                         # Canonizalized Headers
                         "x-ms-version:#{api_version}\n" +                    # Canonizalized Headers
                         "/#{storage_account_name}/#{@storage_container}\n" + # Canonicalized Resource
                         "comp:list\nrestype:container"                       # Additional query parameters
        # rubocop:enable Style/StringConcatenation

        signature = Base64.strict_encode64(OpenSSL::HMAC.digest('sha256', Base64.decode64(storage_account_key), string_to_sign))
        uri = URI("https://#{storage_account_name}.blob.core.windows.net/#{@storage_container}?restype=container&comp=list")

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        request = Net::HTTP::Get.new(uri.request_uri)
        request['x-ms-date'] = timestamp
        request['x-ms-version'] = api_version
        request['Authorization'] = "SharedKey #{storage_account_name}:#{signature}"

        response = http.request(request)

        raise StorageAssetService::Azure::InvalidRequestError, "Error: #{response.code} - #{response.message}" unless response.code == '200'

        response
      end
    end
  end
end
