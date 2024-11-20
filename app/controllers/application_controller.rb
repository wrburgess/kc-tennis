class ApplicationController < ActionController::Base
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protect_from_forgery with: :exception
  add_flash_types :info, :error, :warning

  def controller_class
    controller_name.classify.constantize
  end

  def controller_class_plural
    controller_name.underscore.pluralize
  end

  def controller_class_singular
    controller_name.underscore.singularize
  end

  private

  def index_archivable_params
    if !params[:q]
      params[:q] = { archived_at_not_null: 0 }
    elsif !params.dig(:q, :archived_at_not_null)
      params[:q].merge!({ archived_at_not_null: 0 })
    end

    params.require(:q).permit(:archived_at_not_null)
  end

  def user_not_authorized
    flash[:error] = 'You are not authorized to perform this action.'
    redirect_to(root_path)
  end
end
