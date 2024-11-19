class ReportPolicy < ApplicationPolicy
  def user_export_xlsx?
    user_access_authorized?(:user_export_xlsx)
  end
end
