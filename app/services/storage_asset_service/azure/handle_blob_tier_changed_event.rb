module StorageAssetService
  module Azure
    class HandleBlobTierChangedEvent
      def initialize(event)
        @event = event
        @data = event['data']
      end

      def call
        private_blob_url = Addressable::URI.encode(@data['url'])
        blob_path = URI(private_blob_url).path
        blob_file_name = blob_path.split('/').last

        file_extension = File.extname(blob_file_name).downcase.delete('.')
        return if file_extension.blank? || !FileOptions.all.include?(file_extension)

        storage_asset = StorageAsset.azure.find_by(full_path: blob_path)

        if storage_asset.present?
          blob_properties = StorageAssetService::Azure::GetBlobProperties.new(blob_path).call
          storage_asset.update!(access_tier: blob_properties['x-ms-access-tier'], asset_updated_at: Time.parse(blob_properties['Last-Modified']))
        else
          Rails.logger.info("StorageAssetService::Azure::HandleBlobTierChangedEvent: No storage asset found for private blob URL #{@data['url']}")
        end
      end
    end
  end
end
