class StorageAsset < ApplicationRecord
  validates :service, presence: true
  validates :name, presence: true
  validates :full_path, presence: true
  validates :size_bytes, presence: true, numericality: { only_integer: true }

  scope :azure, -> { where(service: StorageAssetServices::AZURE) }
  scope :dropbox, -> { where(service: StorageAssetServices::DROPBOX) }
  scope :s3, -> { where(service: StorageAssetServices::S3) }
  scope :sharepoint, -> { where(service: StorageAssetServices::SHAREPOINT) }

  def file_extension
    full_path.split('.').last
  end

  def allow_temporary_url?
    return false if service == StorageAssetServices::AZURE && access_tier == StorageAssetServiceTiers::AZURE::ARCHIVE
    return false if service == StorageAssetServices::AZURE && access_tier == StorageAssetServiceTiers::AZURE::UNARCHIVING
    return false if service == StorageAssetServices::S3 && access_tier == StorageAssetServiceTiers::AWS::GLACIER
    return false if service == StorageAssetServices::S3 && access_tier == StorageAssetServiceTiers::AWS::DEEP_ARCHIVE
    return false if service == StorageAssetServices::S3 && access_tier == StorageAssetServiceTiers::AWS::UNARCHIVING

    true
  end

  def self.process_dropbox_assets(assets)
    return if assets[:entries].empty?

    assets[:entries].each do |asset|
      case asset[:'.tag']
      when 'file'
        file_extension = File.extname(asset[:name]).downcase.delete('.')
        next if file_extension.blank? || !FileOptions.all.include?(file_extension)

        attrs = {
          service: StorageAssetServices::DROPBOX,
          full_path: asset[:path_display],
          name: asset[:name],
          size_bytes: asset[:size],
          asset_updated_at: Time.parse(asset[:server_modified])
        }

        upsert(attrs, unique_by: :full_path)
      when 'deleted'
        storage_asset = StorageAsset.dropbox.find_by(full_path: asset[:path_display])

        if storage_asset.present?
          storage_asset.destroy
        else
          Rails.logger.info("StorageAsset.process_dropbox_assets: No storage asset found for Dropbox path #{asset[:path_display]}")
        end
      end
    end
  end

  def generate_temporary_url!
    return if temporary_url.present? && temporary_url_expires_at > Time.current

    temporary_url = case service
                    when StorageAssetServices::AZURE
                      StorageAssetService::Azure::GenerateTemporaryUrl.new(self).call
                    when StorageAssetServices::DROPBOX
                      StorageAssetService::Dropbox::GenerateTemporaryUrl.new(self).call
                    when StorageAssetServices::S3
                      StorageAssetService::S3::GenerateTemporaryUrl.new(self).call
                    when StorageAssetServices::SHAREPOINT
                      StorageAssetService::MicrosoftGraph::GenerateTemporaryUrl.new(self).call
                    end

    update_columns(temporary_url: temporary_url[:url], temporary_url_expires_at: temporary_url[:expires_at])
  end

  def unarchive_on_azure!
    StorageAssetService::Azure::UnarchiveBlob.new(self).call
    update!(access_tier: StorageAssetServiceTiers::AZURE::UNARCHIVING)
  end

  def unarchive_on_s3!
    StorageAssetService::S3::RestoreObject.new(self).call
    update!(access_tier: StorageAssetServiceTiers::AWS::UNARCHIVING)
  end

  def root_folder
    full_path.split('/').compact_blank.first
  end

  def key
    full_path.split('/').compact_blank.drop(1).join('/')
  end
end
