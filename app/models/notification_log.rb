class DataLog < ApplicationRecord
  belongs_to :loggable, polymorphic: true

  belongs_to :title, foreign_key: :loggable_id, foreign_type: :loggable_type, class_name: :Title, polymorphic: true
  belongs_to :episode, foreign_key: :loggable_id, foreign_type: :loggable_type, class_name: :Episode, polymorphic: true

  belongs_to :user

  scope :titles, -> { where(loggable_type: LoggableTypes::TITLE) }
  scope :episodes, -> { where(loggable_type: LoggableTypes::EPISODE) }
end
