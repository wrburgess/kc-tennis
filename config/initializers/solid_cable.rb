ActiveSupport.on_load(:active_record) do
  Rails.application.configure do
    config.solid_cable = {
      primary: :primary
    }
  end
end
