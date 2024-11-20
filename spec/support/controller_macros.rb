module ControllerMacros
  def login_user
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user = create(:user, confirmed_at: Time.current)
      sign_in user
    end
  end
end
