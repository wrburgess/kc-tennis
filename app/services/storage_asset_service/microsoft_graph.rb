module StorageAssetService
  module MicrosoftGraph
    BASE_URL = 'https://graph.microsoft.com/v1.0'.freeze

    class InvalidRequestError < StandardError; end
  end
end
