class Link < ApplicationRecord
  include Archivable
  include Loggable

  validates :url, presence: true

  scope :select_order, -> { order(url_type: :asc) }

  def self.ransackable_attributes(auth_object = nil)
    %w[url_type url video_type id created_at updated_at archived_at]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  def self.options_for_select
    select_order.map { |instance| [instance.name, instance.id] }
  end

  def self.default_sort
    [name: :asc, created_at: :desc]
  end

  def name
    url
  end
end
