class Admin::SystemPermissionsController < AdminController
  include Pagy::Backend

  before_action :authenticate_user!

  def index
    authorize(controller_class)
    @q = controller_class.ransack(params[:q])
    @q.sorts = controller_class.default_sort if @q.sorts.empty?
    @pagy, @instances = pagy(@q.result)
    @instance = controller_class.new
  end

  def show
    authorize(controller_class)
    @instance = controller_class.includes(:users, :system_groups, :system_roles).find(params[:id])
  end

  def new
    authorize(controller_class)
    @instance = controller_class.new
  end

  def create
    authorize(controller_class)
    instance = controller_class.create(create_params)
    instance.update_associations(params)

    instance.log(user: current_user, operation: action_name, meta: params.to_json)
    flash[:success] = "New #{instance.class_name_title} successfully created"
    redirect_to polymorphic_path([:admin, instance])
  end

  def edit
    authorize(controller_class)
    @instance = controller_class.find(params[:id])
  end

  def update
    authorize(controller_class)
    instance = controller_class.find(params[:id])
    original_instance = instance.dup

    instance.update(update_params)
    instance.update_associations(params)
    instance.log(user: current_user, operation: action_name, meta: params.to_json, original_data: original_instance.attributes.to_json)
    flash[:success] = "#{instance.class_name_title} successfully updated"

    redirect_to polymorphic_path([:admin, instance])
  end

  def destroy
    authorize(controller_class)
    instance = controller_class.find(params[:id])

    instance.log(user: current_user, operation: action_name)
    flash[:danger] = "#{instance.class_name_title} successfully deleted"

    instance.destroy

    redirect_to polymorphic_path([:admin, controller_class])
  end

  def copy
    authorize(controller_class)
    instance = controller_class.find(params[:id])
    new_instance = instance.copy_with_associations

    instance.log(user: current_user, operation: action_name, meta: params.to_json)
    flash[:danger] = "#{new_instance.class_name_title} successfully duplicated"
    redirect_to polymorphic_path([:admin, new_instance])
  end

  def collection_export_xlsx
    authorize(controller_class)

    sql = %(
      SELECT
        *
      FROM
        system_permissions
      ORDER BY
        system_permissions.id;
    )

    @results = ActiveRecord::Base.connection.select_all(sql)
    file_name = controller_class_plural
    filepath = "#{Rails.root}/tmp/#{file_name}.xlsx"

    File.open(filepath, 'wb') do |f|
      f.write render_to_string(handlers: [:axlsx], formats: [:xlsx], template: 'xlsx/reports', layout: false)
    end

    instance.log(user: current_user, action_type: action_name, meta: params.to_json)
    render(xlsx: 'reports', handlers: [:axlsx], formats: [:xlsx], template: 'xlsx/reports', filename: "#{file_name}_#{DateTime.now.strftime('%Y-%m-%d_%H-%M-%S')}.xlsx", layout: false)
  end

  private

  def create_params
    params.require(controller_class_symbolized).permit(
      :abbreviation,
      :description,
      :name,
      :notes,
      :operation,
      :resource,
    )
  end

  def update_params
    params.require(controller_class_symbolized).permit(
      :abbreviation,
      :description,
      :name,
      :notes,
      :operation,
      :resource,
    )
  end
end
