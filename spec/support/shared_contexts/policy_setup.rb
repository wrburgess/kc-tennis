RSpec.shared_context 'policy_setup' do
  let(:user) { create(:user) }
  let(:klass) { described_class.to_s.gsub('Policy', '').constantize }
  let(:policy) { described_class.new(user, klass) }

  let(:system_group) { create(:system_group) }
  let(:system_role) { create(:system_role) }
  let(:sp_collection_export_xlsx) { create(:system_permission, name: "#{klass} Collection Export Xlsx", resource: klass, operation: 'collection_export_xlsx') }
  let(:sp_copy) { create(:system_permission, name: "#{klass} Copy", resource: klass, operation: 'copy') }
  let(:sp_create) { create(:system_permission, name: "#{klass} Create", resource: klass, operation: 'create') }
  let(:sp_destroy) { create(:system_permission, name: "#{klass} Destroy", resource: klass, operation: 'destroy') }
  let(:sp_edit) { create(:system_permission, name: "#{klass} Edit", resource: klass, operation: 'edit') }
  let(:sp_index) { create(:system_permission, name: "#{klass} Index", resource: klass, operation: 'index') }
  let(:sp_member_export_xlsx) { create(:system_permission, name: "#{klass} Member Export Xlsx", resource: klass, operation: 'member_export_xlsx') }
  let(:sp_new) { create(:system_permission, name: "#{klass} New", resource: klass, operation: 'new') }
  let(:sp_show) { create(:system_permission, name: "#{klass} Show", resource: klass, operation: 'show') }
  let(:sp_update) { create(:system_permission, name: "#{klass} Update", resource: klass, operation: 'update') }

  before do
    system_role.system_permissions << [
      sp_collection_export_xlsx,
      sp_copy,
      sp_create,
      sp_destroy,
      sp_edit,
      sp_index,
      sp_member_export_xlsx,
      sp_new,
      sp_show,
      sp_update,
    ]
    system_group.system_roles << system_role
    system_group.users << user
  end
end
