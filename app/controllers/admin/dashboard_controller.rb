class Admin::DashboardController < AdminController
  before_action :authenticate_user!

  def index; end
end
