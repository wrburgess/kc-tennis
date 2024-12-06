class Admin::DashboardCard::Component < ApplicationComponent
  renders_many :links, DashboardLink::Component

  def initialize(title:)
    @title = title
  end

  class DashboardLink::Component < ApplicationComponent
    def initialize(name:, url:, policy: nil, new_window: false)
      @name = name
      @url = url
      @policy = policy
      @new_window = new_window
    end

    def render?
      return true if @policy.nil?

      Pundit.policy(Current.user, @policy).index?
    end

    def call
      link = if @new_window
               link_to(@name, @url, target: '_blank', rel: 'noopener noreferrer')
             else
               link_to(@name, @url)
             end

      content_tag(:li, link)
    end
  end
end
