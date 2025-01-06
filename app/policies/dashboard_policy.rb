class DashboardPolicy < ApplicationPolicy
  def initialize(user, _record)
    @user = user
  end

  def index?
    user.has_system_permission?
  end
end
