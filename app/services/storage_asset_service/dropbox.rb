module StorageAssetService
  module Dropbox
    BASE_URL = 'https://api.dropboxapi.com'.freeze

    class InvalidRequestError < StandardError; end
  end
end
