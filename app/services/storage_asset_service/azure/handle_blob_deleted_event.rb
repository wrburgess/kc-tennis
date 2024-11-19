module StorageAssetService
  module Azure
    class HandleBlobDeletedEvent
      def initialize(event)
        @event = event
        @data = event['data']
      end

      def call
        private_blob_url = Addressable::URI.encode(@data['url'])
        blob_path = URI(private_blob_url).path
        storage_asset = StorageAsset.azure.find_by(full_path: blob_path)

        if storage_asset.present?
          storage_asset.destroy
        else
          Rails.logger.info("StorageAssetService::Azure::HandleBlobDeletedEvent: No storage asset found for private blob URL #{@data['url']}")
        end
      end
    end
  end
end
