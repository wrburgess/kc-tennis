Rails.application.configure do
  config.solid_cable = {
    primary: :primary,
    replica: :primary # Point replica to primary since we're using single database
  }
end
