module StorageAssetService
  module S3
    class HandleRestoreExpiredEvent
      def initialize(message)
        @message = message
      end

      def call
        bucket_name = @message.dig('detail', 'bucket', 'name')
        key = @message.dig('detail', 'object', 'key')

        client = StorageAssetService::S3::Client.new.call
        head_object = client.head_object(bucket: bucket_name, key: key)

        storage_asset = StorageAsset.s3.find_by(full_path: "/#{bucket_name}/#{key}")

        if storage_asset.present?
          storage_asset.update!(
            access_tier: head_object.storage_class || StorageAssetServiceTiers::AWS::STANDARD,
            asset_updated_at: head_object.last_modified
          )
        else
          Rails.logger.info("StorageAssetService::S3::HandleRestoreExpiredEvent: No storage asset found for object URL /#{bucket_name}/#{key}")
        end
      end
    end
  end
end
