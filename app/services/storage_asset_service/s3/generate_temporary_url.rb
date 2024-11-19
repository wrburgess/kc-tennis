module StorageAssetService
  module S3
    class GenerateTemporaryUrl
      EXPIRES_IN_SECONDS = 3600

      def initialize(storage_asset)
        @storage_asset = storage_asset
      end

      def call
        client = StorageAssetService::S3::Client.new.call
        signer = Aws::S3::Presigner.new(client:)
        url = signer.presigned_url(:get_object, bucket: @storage_asset.root_folder, key: @storage_asset.key, expires_in: EXPIRES_IN_SECONDS)

        {
          url:,
          expires_at: EXPIRES_IN_SECONDS.seconds.from_now
        }
      end
    end
  end
end
