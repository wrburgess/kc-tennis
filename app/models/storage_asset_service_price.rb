class StorageAssetServicePrice < ApplicationRecord
  validates :storage_asset_service, presence: true
  validates :storage_asset_service_tier, presence: true
  validates :storage_asset_service_region, presence: true
  validates :price_per_gb_per_month, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :active, -> { where(archived_at: nil) }
  scope :select_order, -> { order(priority: :asc) }

  def name
    storage_asset_service
  end
end
