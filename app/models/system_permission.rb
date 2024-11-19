class SystemPermission < ApplicationRecord
  include Loggable

  validates_presence_of :name
  validates_presence_of :resource
  validates_presence_of :operation

  has_many :system_role_system_permissions, dependent: :destroy
  has_many :system_roles, through: :system_role_system_permissions

  has_many :system_groups, through: :system_roles
  has_many :users, through: :system_groups

  scope :select_order, -> { order(name: :asc) }

  def self.options_for_select
    select_order.map { |instance| [instance.name, instance.id] }
  end

  def update_associations(params)
    SystemPermission.transaction do
      system_role_system_permissions.delete_all if params[:system_role_ids].present?
      params[:system_role_ids]&.each do |system_role_id|
        SystemRoleSystemPermission.create(system_permission: self, system_role_id:)
      end
    end
  end
end
