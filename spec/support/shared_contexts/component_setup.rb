RSpec.shared_context 'component_setup' do
  let(:user) { create(:user) }
  let(:klass) { Title }
  let(:klass_sale) { Sale }
  let(:klass_report) { Report }
  let(:policy_title) { described_class.new(user, klass) }
  let(:policy_sale) { described_class.new(user, klass_sale) }
  let(:policy_report) { described_class.new(user, klass_report) }

  let(:system_group) { create(:system_group) }
  let(:system_role) { create(:system_role) }
  let(:sp_index) { create(:system_permission, name: "#{klass} Index", resource: klass, operation: 'index') }
  let(:sp_show) { create(:system_permission, name: "#{klass} Show", resource: klass, operation: 'show') }
  let(:sp_new) { create(:system_permission, name: "#{klass} New", resource: klass, operation: 'new') }
  let(:sp_create) { create(:system_permission, name: "#{klass} Create", resource: klass, operation: 'create') }
  let(:sp_edit) { create(:system_permission, name: "#{klass} Edit", resource: klass, operation: 'edit') }
  let(:sp_update) { create(:system_permission, name: "#{klass} Update", resource: klass, operation: 'update') }
  let(:sp_destroy) { create(:system_permission, name: "#{klass} Destroy", resource: klass, operation: 'destroy') }
  let(:sp_collection_export_xlsx) { create(:system_permission, name: "#{klass} Collection Export Xlsx", resource: klass, operation: 'collection_export_xlsx') }
  let(:sp_copy) { create(:system_permission, name: "#{klass_sale} Copy", resource: klass_sale, operation: 'copy') }
  let(:sp_member_export_xlsx) { create(:system_permission, name: "#{klass_report} Member Export Xlsx", resource: klass_report, operation: 'member_export_xlsx') }

  before do
    system_role.system_permissions << [sp_index, sp_show, sp_new, sp_create, sp_edit, sp_update, sp_destroy, sp_collection_export_xlsx, sp_copy, sp_member_export_xlsx]
    system_group.system_roles << system_role
    system_group.users << user
  end
end
