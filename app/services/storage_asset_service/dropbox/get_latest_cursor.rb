module StorageAssetService
  module Dropbox
    class GetLatestCursor
      def call
        root_namespace_id = Rails.application.credentials.dig(:storage_assets, :dropbox, :root_namespace_id)

        access_token = StorageAssetSession.dropbox_access_token

        uri = URI("#{BASE_URL}/2/files/list_folder/get_latest_cursor")

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        request = Net::HTTP::Post.new(uri.request_uri)
        request['Authorization'] = "Bearer #{access_token.value}"
        request['Content-Type'] = 'application/json'
        request['Dropbox-API-Path-Root'] = { ".tag": 'root', root: root_namespace_id }.to_json
        request.body = {
          path: ''
        }.to_json

        response = http.request(request)

        raise StorageAssetService::Dropbox::InvalidRequestError, "Error: #{response.code} - #{response.body}" unless response.code == '200'

        response_body = JSON.parse(response.body)

        response_body['cursor']
      end
    end
  end
end
