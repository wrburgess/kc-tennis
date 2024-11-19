module StorageAssetService
  module S3
    class HandleDeletedEvent
      def initialize(message)
        @message = message
      end

      def call
        bucket_name = @message.dig('detail', 'bucket', 'name')
        key = @message.dig('detail', 'object', 'key')

        storage_asset = StorageAsset.s3.find_by(full_path: "/#{bucket_name}/#{key}")

        if storage_asset.present?
          storage_asset.destroy
        else
          Rails.logger.info("StorageAssetService::S3::HandleDeletedEvent: No storage asset found for object URL /#{bucket_name}/#{key}")
        end
      end
    end
  end
end
