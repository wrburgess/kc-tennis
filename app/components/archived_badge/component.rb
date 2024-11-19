class ArchivedBadge::Component < ApplicationComponent
  def initialize(archived_at:)
    @archived_at = archived_at
  end

  def render?
    @archived_at.present?
  end

  def style
    {
      base: 'badge badge-warning ms-1'
    }
  end
end
