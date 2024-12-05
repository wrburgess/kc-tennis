Rails.application.config.to_prepare do
  Rails.application.configure do
    config.solid_cable = {
      primary: :primary,
      replica: :primary
    }
  end

  ActiveRecord::Base.establish_connection(
    ActiveRecord::Base.configurations.configs_for(env_name: Rails.env, name: 'primary').configuration_hash
  )
end
