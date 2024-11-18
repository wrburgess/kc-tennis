module StorageAssetServices
  ALIBABA_COSS = 'alibaba-coss'.freeze
  AWS_S3 = 'aws-s3'.freeze
  AZURE = 'azure'.freeze
  BACKBLAZE = 'backblaze'.freeze
  BOX = 'box'.freeze
  CLOUDFLARE_R2 = 'cloudflare-r2'.freeze
  DIGITALOCEAN_SPACES = 'digitalocean-spaces'.freeze
  DROPBOX = 'dropbox'.freeze
  S3 = 's3'.freeze
  SHAREPOINT = 'sharepoint'.freeze

  def self.options_for_select
    all.map { |item| [item.capitalize, item] }
  end

  def self.all
    [
      StorageAssetServices::AZURE,
      StorageAssetServices::DROPBOX,
      StorageAssetServices::S3,
      StorageAssetServices::SHAREPOINT
    ]
  end
end
