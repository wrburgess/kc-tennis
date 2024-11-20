Rails.application.routes.draw do
  devise_for :users

  root to: "static#index"
  get "up" => "rails/health#show", as: :rails_health_check

  concern :copyable do
    member do
      post :copy
    end
  end

  concern :collection_exportable do
    collection do
      get :export_xlsx
    end
  end

  concern :member_exportable do
    member do
      get :export_xlsx
    end
  end

  concern :importable do
    collection do
      get :upload
      post :import
      get :export_example
    end
  end

  scope "/admin" do
    authenticate :user, lambda { |u| u.admin? } do
      mount GoodJob::Engine, at: :good_job
      mount MaintenanceTasks::Engine, at: :maintenance_tasks
    end

    if Rails.env.development?
      authenticate :user, lambda { |u| u.admin? } do
        mount Lookbook::Engine, at: :lookbook
      end
    end

    resources :contacts, concerns: :collection_exportable
    resources :data_logs, only: [:index, :show], concerns: :collection_exportable
    resources :links, concerns: :collection_exportable
    resources :organizations, concerns: :collection_exportable

    resources :reports, concerns: [:collection_exportable, :member_exportable]

    resources :storage_assets, only: [:index, :show] do
      member do
        post :unarchive_on_azure
        post :unarchive_on_s3
      end
    end

    resources :storage_asset_service_prices, concerns: [:collection_exportable, :importable]
    resources :system_groups, concerns: :collection_exportable
    resources :system_permissions, concerns: :collection_exportable
    resources :system_roles, concerns: :collection_exportable

    resources :users, concerns: :collection_exportable do
      member do
        put :trigger_password_reset_email
      end
    end
  end
end
