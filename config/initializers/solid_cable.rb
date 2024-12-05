Rails.configuration.after_initialize do
  Rails.application.configure do
    config.solid_cable = {
      primary: :primary,
      connections: {
        primary: { role: :writing }
      }
    }
  end
end
