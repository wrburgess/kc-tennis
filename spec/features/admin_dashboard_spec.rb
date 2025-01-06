require 'rails_helper'

describe 'Admin Dashboard', type: :feature do
  let(:user) { create(:user) }
  let(:system_group) { create(:system_group) }
  let(:system_role) { create(:system_role) }
  let(:sp_index) { create(:system_permission, name: 'Dashboard Index', resource: 'Dashboard', operation: 'index') }
  let(:policy) { described_class.new(user, :dashboard) }

  before do
    login_as(user, scope: :user)
  end

  context 'when user is authorized' do
    before do
      system_role.system_permissions << sp_index
      system_group.system_roles << system_role
      system_group.users << user
    end

    scenario 'User visits dashboard' do
      visit admin_root_path

      expect(page).to have_current_path(admin_root_path)
      expect(page).to have_text('Dashboard')
    end
  end

  context 'when user is not authorized' do
    scenario 'User is redirected from dashboard' do
      visit admin_root_path

      expect(page).to have_current_path(root_path)
      expect(page).to have_text('You are not authorized to perform this action')
    end
  end
end
