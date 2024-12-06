class Admin::DashboardCard::Component < ApplicationComponent
  renders_many :links, Admin::DashboardLink::Component

  def initialize(title:)
    @title = title
  end
end
