module StorageAssetService
  module MicrosoftGraph
    class GetDriveItem
      def initialize(storage_asset, token)
        @storage_asset = storage_asset
        @token = token
      end

      def call
        drive_id = Rails.application.credentials.dig(:storage_assets, :microsoft_graph, :sharepoint_documents_drive_id)
        uri = URI("#{BASE_URL}/drives/#{drive_id}/root:#{URI.encode_uri_component(@storage_asset.full_path)}")

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        request = Net::HTTP::Get.new(uri.request_uri)
        request['Authorization'] = "Bearer #{@token}"

        response = http.request(request)

        raise InvalidRequestError, "Error: #{response.code} - #{response.message}" unless response.code == '200'

        JSON.parse(response.body).deep_symbolize_keys
      end
    end
  end
end
