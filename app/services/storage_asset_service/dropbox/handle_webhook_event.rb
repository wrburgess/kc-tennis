module StorageAssetService
  module Dropbox
    class HandleWebhookEvent
      def call
        access_token = StorageAssetSession.dropbox_access_token
        cursor = StorageAssetSession.dropbox_cursor

        dropbox_assets = StorageAssetService::Dropbox::ListFoldersContinue.new(access_token.value, cursor.value).call
        StorageAsset.process_dropbox_assets(dropbox_assets)

        while dropbox_assets[:has_more]
          dropbox_assets = StorageAssetService::Dropbox::ListFoldersContinue.new(access_token.value, dropbox_assets[:cursor]).call
          StorageAsset.process_dropbox_assets(dropbox_assets)
        end

        cursor.update(value: dropbox_assets[:cursor])
      end
    end
  end
end
