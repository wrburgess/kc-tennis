module StorageAssetService
  module Dropbox
    class ListFoldersContinue
      def initialize(token, cursor)
        @token = token
        @cursor = cursor
      end

      def call
        root_namespace_id = Rails.application.credentials.dig(:storage_assets, :dropbox, :root_namespace_id)

        uri = URI("#{BASE_URL}/2/files/list_folder/continue")

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        request = Net::HTTP::Post.new(uri.request_uri)
        request['Authorization'] = "Bearer #{@token}"
        request['Content-Type'] = 'application/json'
        request['Dropbox-API-Path-Root'] = { ".tag": 'root', root: root_namespace_id }.to_json
        request.body = { cursor: @cursor }.to_json

        response = http.request(request)

        raise StorageAssetService::Dropbox::InvalidRequestError, "Error: #{response.code} - #{response.body}" unless response.code == '200'

        JSON.parse(response.body).deep_symbolize_keys
      end
    end
  end
end
