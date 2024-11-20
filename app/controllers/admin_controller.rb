class AdminController < ApplicationController
  layout 'admin'

  before_action :authenticate_user!

  def destroy
    @instance = @model_class.find(params[:id])
    authorize(@instance)

    @instance.archive!
    @instance.log(user: current_user, operation: action_nameD)
    flash[:danger] = "#{@instance.class_name_title} archived"
    redirect_to polymorphic_path([:admin, @model_class])
  end

  def unarchive
    @instance = @model_class.find(params[:id])
    authorize(@instance)

    @instance.unarchive!
    @instance.log(user: current_user, operation: action_name)
    flash[:danger] = "#{@instance.class_name_title} unarchived"
    redirect_to polymorphic_path([:admin, @model_class])
  end
end
