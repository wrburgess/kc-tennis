module StorageAssetService
  module MicrosoftGraph
    class Oauth2Token
      def call
        directory_tenant_id = Rails.application.credentials.dig(:storage_assets, :microsoft_graph, :directory_tenant_id)
        client_id = Rails.application.credentials.dig(:storage_assets, :microsoft_graph, :app_client_id)
        client_secret = Rails.application.credentials.dig(:storage_assets, :microsoft_graph, :app_client_secret)

        uri = URI("https://login.microsoftonline.com/#{directory_tenant_id}/oauth2/v2.0/token")

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        request = Net::HTTP::Post.new(uri.request_uri)
        request.set_form_data(
          grant_type: 'client_credentials',
          scope: 'https://graph.microsoft.com/.default',
          client_id:,
          client_secret:
        )

        response = http.request(request)

        raise StorageAssetService::MicrosoftGraph::InvalidRequestError, "Error: #{response.code} - #{response.body}" unless response.code == '200'

        JSON.parse(response.body).deep_symbolize_keys
      end
    end
  end
end
