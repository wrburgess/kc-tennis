class Link < ApplicationRecord
  include Archivable
  include Loggable

  validates :url, presence: true

  scope :select_order, -> { order(url_type: :asc) }

  def self.options_for_select
    select_order.map { |instance| [instance.name, instance.id] }
  end

  def name
    url
  end
end
