module StorageAssetService
  module Azure
    class HandleBlobCreatedEvent
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

        # Ignore the file if by chance it already exists in the database. This shouldn't
        # happen, but renaming a blob in Azure Storage seems to delete the file first and
        # recreate it with the new name, triggering both the `Microsoft.Storage.BlobDeleted`
        # and `Microsoft.Storage.BlobCreated` events. Since there's no guarantee that the
        # events will be processed in order, we need to handle this case.
        return if StorageAsset.azure.exists?(full_path: blob_path)

        blob_properties = StorageAssetService::Azure::GetBlobProperties.new(blob_path).call

        StorageAsset.create!({
                               service: StorageAssetServices::AZURE,
                               full_path: blob_path,
                               name: blob_file_name,
                               size_bytes: blob_properties['Content-Length'].to_i,
                               access_tier: blob_properties['x-ms-access-tier'],
                               asset_created_at: Time.parse(blob_properties['x-ms-creation-time']),
                               asset_updated_at: Time.parse(blob_properties['Last-Modified'])
                             })
      end
    end
  end
end
