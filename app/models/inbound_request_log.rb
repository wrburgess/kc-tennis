class WebhookLog < ApplicationRecord
  validates :service, presence: true
  validates :meta, presence: true
end
