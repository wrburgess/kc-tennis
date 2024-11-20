class ApplicationController < ActionController::Base
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protect_from_forgery with: :exception
  add_flash_types :info, :error, :warning

  private

  def index_archivable_params
    if !params[:q]
      params[:q] = { archived_at_not_null: 0 }
    elsif !params.dig(:q, :archived_at_not_null)
      params[:q].merge!({ archived_at_not_null: 0 })
    end

    params.required(:q).permit!
  end

  def user_not_authorized
    flash[:error] = 'You are not authorized to perform this action.'
    redirect_to(root_path)
  end
end
