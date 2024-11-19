module StorageAssetService
  module Dropbox
    class Oauth2Token
      def call
        client_id = Rails.application.credentials.dig(:storage_assets, :dropbox, :client_id)
        client_secret = Rails.application.credentials.dig(:storage_assets, :dropbox, :client_secret)
        refresh_token = Rails.application.credentials.dig(:storage_assets, :dropbox, :refresh_token)

        uri = URI("#{BASE_URL}/oauth2/token")

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        request = Net::HTTP::Post.new(uri.request_uri)
        request.set_form_data(
          grant_type: 'refresh_token',
          refresh_token:,
          client_id:,
          client_secret:
        )

        response = http.request(request)

        raise StorageAssetService::Dropbox::InvalidRequestError, "Error: #{response.code} - #{response.body}" unless response.code == '200'

        JSON.parse(response.body).deep_symbolize_keys
      end
    end
  end
end
