module StorageAssetService
  module S3
    class RestoreObject
      DAYS_TO_RESTORE = 7

      def initialize(storage_asset)
        raise ArgumentError, 'The storage asset service must be S3' unless storage_asset.service == StorageAssetServices::S3
        raise ArgumentError, 'The storage asset must be archived using Glacier Flexible or Deep Archive' unless [StorageAssetServiceTiers::AWS::GLACIER, StorageAssetServiceTiers::AWS::DEEP_ARCHIVE].include?(storage_asset.access_tier)

        @storage_asset = storage_asset
      end

      def call
        client = StorageAssetService::S3::Client.new.call
        client.restore_object(
          bucket: @storage_asset.root_folder,
          key: @storage_asset.key,
          restore_request: {
            days: DAYS_TO_RESTORE,
            glacier_job_parameters: { tier: 'Standard' }
          }
        )
      end
    end
  end
end
