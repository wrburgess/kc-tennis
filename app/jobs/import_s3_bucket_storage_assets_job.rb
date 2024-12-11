class ImportS3BucketStorageAssetsJob < ApplicationJob
  queue_as :default

  def perform(bucket_name)
    client = StorageAssetService::S3::Client.new.call
    objects = client.list_objects(bucket: bucket_name)
    process_objects(bucket_name, objects)

    while objects.next_page?
      objects = objects.next_page
      process_objects(bucket_name, objects)
    end
  end

  private

  def process_objects(bucket_name, objects)
    objects.contents.each do |object|
      file_extension = File.extname(object.key).downcase.delete('.')
      next if file_extension.blank? || !FileOptions.all.include?(file_extension)

      attrs = {
        service: StorageAssetServices::S3,
        full_path: "/#{bucket_name}/#{object.key}",
        name: object.key.split('/').last,
        size_bytes: object.size,
        access_tier: object.storage_class,
        asset_updated_at: object.last_modified
      }

      StorageAsset.upsert(attrs, unique_by: :full_path)
    end
  end
end
