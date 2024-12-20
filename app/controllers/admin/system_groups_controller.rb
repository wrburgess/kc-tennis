class Admin::SystemGroupsController < AdminController
  include Pagy::Backend

  before_action :authenticate_user!

  def index
    authorize(controller_class)
    @q = controller_class.ransack(params[:q])
    @q.sorts = ['name asc', 'created_at desc'] if @q.sorts.empty?
    @pagy, @instances = pagy(@q.result)
    @instance = controller_class.new
  end

  def show
    authorize(controller_class)
    @instance = controller_class.includes(:users, :system_roles, :system_permissions).find(params[:id])
  end

  def new
    authorize(controller_class)
    @instance = controller_class.new
  end

  def create
    authorize(controller_class)
    params[:active] = params[:active].present? ? true : false
    instance = controller_class.create(create_params)

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

  def export_xlsx
    authorize(controller_class)

    sql = %(
      SELECT
        *
      FROM
        system_groups
      ORDER BY
        system_groups.id;
    )

    @results = ActiveRecord::Base.connection.select_all(sql)
    file_name = controller_class_instances

    send_data(
      render_to_string(
        template: 'admin/xlsx/reports',
        formats: [:xlsx],
        handlers: [:axlsx],
        layout: false
      ),
      filename: helpers.file_name_with_timestamp(file_name: file_name, file_extension: 'xlsx'),
      type: Mime[:xlsx]
    )
  end

  private

  def create_params
    params.permit(
      :abbreviation,
      :description,
      :name,
      :notes,
    )
  end

  def update_params
    params.permit(
      :abbreviation,
      :description,
      :name,
      :notes,
    )
  end
end
