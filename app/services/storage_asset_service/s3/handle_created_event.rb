module StorageAssetService
  module S3
    class HandleCreatedEvent
      def initialize(message)
        @message = message
      end

      def call
        bucket_name = @message.dig('detail', 'bucket', 'name')
        key = @message.dig('detail', 'object', 'key')

        client = StorageAssetService::S3::Client.new.call
        head_object = client.head_object(bucket: bucket_name, key: key)

        attrs = {
          service: StorageAssetServices::S3,
          full_path: "/#{bucket_name}/#{key}",
          name: key,
          size_bytes: @message.dig('detail', 'object', 'size'),
          access_tier: head_object.storage_class || StorageAssetServiceTiers::AWS::STANDARD,
          asset_updated_at: Time.parse(@message['time'])
        }

        StorageAsset.upsert(attrs, unique_by: :full_path)
      end
    end
  end
end
