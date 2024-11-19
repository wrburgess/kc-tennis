class UserPolicy < ApplicationPolicy
  def trigger_password_reset_email?
    user_access_authorized?(:trigger_password_reset_email)
  end
end
