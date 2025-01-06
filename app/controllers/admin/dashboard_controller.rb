class Admin::DashboardController < AdminController
  before_action :authenticate_user!

  def index
    authorize(controller_class)
  end
end
