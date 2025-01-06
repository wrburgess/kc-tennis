class UserPolicy < ApplicationPolicy
  def trigger_password_reset_email?
    user_access_authorized?(:trigger_password_reset_email)
  end

  def impersonate?
    user_access_authorized?(:impersonate)
  end

  def stop_impersonating?
    user_access_authorized?(:impersonate)
  end
end
