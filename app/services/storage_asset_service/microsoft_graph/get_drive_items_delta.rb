module StorageAssetService
  module MicrosoftGraph
    class GetDriveItemsDelta
      SELECT_PARAMS = ['createdDateTime', 'lastModifiedDateTime', 'name', 'size', 'id', 'file', 'folder', 'parentReference', 'content.downloadUrl'].freeze

      def initialize(drive_id:, access_token:, delta_token: nil)
        @drive_id = drive_id
        @access_token = access_token
        @delta_token = delta_token
      end

      def call
        uri = URI("#{BASE_URL}/drives/#{@drive_id}/root/delta?$select=createdDateTime,lastModifiedDateTime,name,size,id,file,folder,parentReference,content.downloadUrl")

        uri.query = if @delta_token.present?
                      URI.encode_www_form('$select': SELECT_PARAMS.join(','), token: @delta_token)
                    else
                      URI.encode_www_form('$select': SELECT_PARAMS.join(','))
                    end

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        request = Net::HTTP::Get.new(uri.request_uri)
        request['Authorization'] = "Bearer #{@access_token}"

        response = http.request(request)

        raise InvalidRequestError, "Error: #{response.code} - #{response.message}" unless response.code == '200'

        JSON.parse(response.body)
      end
    end
  end
end
