class SystemGroup < ApplicationRecord
  include Loggable

  validates_presence_of :name

  has_many :system_group_users, dependent: :destroy
  has_many :users, through: :system_group_users

  has_many :system_group_system_roles, dependent: :destroy
  has_many :system_roles, through: :system_group_system_roles

  has_many :system_permissions, through: :system_roles

  scope :select_order, -> { order('name ASC') }

  def self.options_for_select
    select_order.map { |instance| [instance.name, instance.id] }
  end

  def update_associations(params)
    SystemGroup.transaction do
      system_group_users.delete_all if params[:user_ids].present?
      params[:user_ids]&.each do |user_id|
        SystemGroupUser.create(system_group: self, user_id:)
      end

      system_group_system_roles.delete_all if params[:system_role_ids].present?
      params[:system_role_ids]&.each do |system_role_id|
        SystemGroupSystemRole.create(system_group: self, system_role_id:)
      end
    end
  end
end