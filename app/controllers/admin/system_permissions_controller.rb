class Admin::SystemPermissionsController < AdminController
  include Pagy::Backend

  before_action :authenticate_user!

  def index
    authorize(controller_class)
    @q = controller_class.ransack(index_archivable_params)
    @q.sorts = ['name asc', 'created_at desc'] if @q.sorts.empty?
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
    params[:active] = params[:active].present? ? true : false
    instance = controller_class.create(create_params)
    instance.update_associations(params)

    instance.log(user: current_user, action_type: DataLogActionTypes::CREATED, meta: params.to_json)
    flash[:success] = "New #{controller_class_instance.titleize} successfully created"
    redirect_to send("#{controller_class_instance}_path", instance)
  end

  def edit
    authorize(controller_class)
    @instance = controller_class.find(params[:id])
  end

  def update
    authorize(controller_class)
    instance = controller_class.find(params[:id])
    original_instance = instance.dup

    params[:active] = params[:active].present? ? true : false
    instance.update(update_params)
    instance.update_associations(params)

    instance.log(user: current_user, action_type: DataLogActionTypes::UPDATED, meta: params.to_json, original_data: original_instance.attributes.to_json)
    flash[:success] = "#{controller_class_instance.titleize} successfully updated"
    redirect_to send("#{controller_class_instance}_path", instance)
  end

  def destroy
    authorize(controller_class)
    instance = controller_class.find(params[:id])
    instance.log(user: current_user, action_type: DataLogActionTypes::DELETED)
    instance.destroy

    flash[:danger] = "#{controller_class_instance.titleize} successfully deleted"
    redirect_to send("#{controller_class_instances}_path")
  end

  def copy
    authorize(controller_class)
    instance = controller_class.find(params[:id])
    new_instance = instance.copy_with_associations

    instance.log(user: current_user, action_type: DataLogActionTypes::DUPLICATED, meta: params.to_json)
    redirect_to send("#{controller_class_instance}_path", new_instance), notice: "Duplicate #{controller_class_instance.titleize} Created!"
  end

  def export_xlsx
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
    file_name = controller_class_instances
    filepath = "#{Rails.root}/tmp/#{file_name}.xlsx"

    File.open(filepath, 'wb') do |f|
      f.write render_to_string(handlers: [:axlsx], formats: [:xlsx], template: 'xlsx/reports')
    end

    render xlsx: 'reports', handlers: [:axlsx], formats: [:xlsx], template: 'xlsx/reports', filename: helpers.file_name_with_timestamp(file_name:, file_extension: 'xlsx')
  end

  private

  def create_params
    params.permit(
      :abbreviation,
      :description,
      :name,
      :notes,
      :operation,
      :resource,
    )
  end

  def update_params
    params.permit(
      :abbreviation,
      :description,
      :name,
      :notes,
      :operation,
      :resource,
    )
  end
end
