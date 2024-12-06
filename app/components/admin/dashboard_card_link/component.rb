class Admin::DashboardLink::Component < ApplicationComponent
  def initialize(name:, url:, policy: nil, new_window: false)
    @name = name
    @url = url
    @policy = policy
    @new_window = new_window
  end

  def render?
    return true if @policy.nil?

    Pundit.policy(current_user, @policy).index?
  end

  def link
    if @new_window
      link_to(@name, @url, target: '_blank', rel: 'noopener noreferrer')
    else
      link_to(@name, @url)
    end
  end
end
