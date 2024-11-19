module StorageAssetService
  module MicrosoftGraph
    class GenerateTemporaryUrl
      def initialize(storage_asset)
        @storage_asset = storage_asset
      end

      def call
        token = StorageAssetSession.microsoft_graph_token.value
        drive_item = StorageAssetService::MicrosoftGraph::GetDriveItem.new(@storage_asset, token).call

        # The download URL typically expires one hour after its retrieval, but it
        # isn't guaranteed. We'll set a shorter expiration time to be on the safe side.
        {
          url: drive_item[:"@microsoft.graph.downloadUrl"],
          expires_at: 30.minutes.from_now
        }
      end
    end
  end
end
