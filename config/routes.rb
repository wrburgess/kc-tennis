Rails.application.routes.draw do
  root to: "static#index"
  get "up" => "rails/health#show", as: :rails_health_check

  devise_for :users
  mount MaintenanceTasks::Engine, at: "/maintenance_tasks"

  scope "/admin" do
    authenticate :user, lambda { |u| u.admin? } do
      mount GoodJob::Engine, at: :good_job
      mount MaintenanceTasks::Engine, at: :maintenance_tasks
    end

    if Rails.env.development? || Rails.env.staging?
      authenticate :user, lambda { |u| u.admin? } do
        mount RailsDb::Engine, at: "/rails/db", as: :rails_db
      end
    end

    if Rails.env.development?
      authenticate :user, lambda { |u| u.admin? } do
        mount Lookbook::Engine, at: :lookbook
      end
    end

    # resources :users, concerns: :exportable do
    #   member do
    #     put :trigger_password_reset_email
    #   end
    # end
  end
end
