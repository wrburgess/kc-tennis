class ApplicationController < ActionController::Base
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protect_from_forgery with: :exception
  add_flash_types :info, :error, :warning

  impersonates :user

  def controller_class
    controller_name.classify.constantize
  end

  def controller_class_plural
    controller_name.underscore.pluralize
  end

  def controller_class_singular
    controller_name.underscore.singularize
  end

  def controller_class_symbolized
    controller_name.underscore.singularize.to_sym
  end

  private

  def user_not_authorized
    flash[:error] = 'You are not authorized to perform this action.'

    render(
      file: Rails.public_path.join('401.html'),
      status: :unauthorized,
      layout: false
    )
  end
end
