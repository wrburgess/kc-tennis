class UsersController < AdminController
  include Pagy::Backend

  before_action :authenticate_user!

  def index
    authorize(controller_class)
    @q = controller_class.actives.ransack(index_archivable_params)
    @q.sorts = ['last_name asc', 'created_at desc'] if @q.sorts.empty?

    @pagy, @instances = pagy(@q.result)
    @instance = controller_class.new
  end

  def show
    authorize(controller_class)
    @instance = controller_class.find(params[:id])
  end

  def new
    authorize(controller_class)
    @instance = controller_class.new
  end

  def create
    authorize(controller_class)
    params[:confirmed_at] = DateTime.current
    instance = controller_class.create(create_params)

    instance.log(user: current_user, operation: action_name, meta: params.to_json)
    flash[:success] = "New #{instance.class_name_title} successfully created"
    redirect_to polymorphic_path(instance)
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

    instance.log(user: current_user, operation: action_name, meta: params.to_json, original_data: original_instance.attributes.to_json)
    flash[:success] = "#{instance.class_name_title} successfully updated"
    redirect_to polymorphic_path(instance)
  end

  def destroy
    authorize(controller_class)
    instance = controller_class.find(params[:id])
    instance.archive

    instance.log(user: current_user, operation: action_name)
    flash[:danger] = "#{instance.class_name_title} successfully deleted"
    redirect_to polymorphic_path(controller_class)
  end

  def trigger_password_reset_email
    authorize(controller_class)
    instance = controller_class.find(params[:id])
    instance.send_reset_password_instructions
    flash[:success] = 'Password reset email sent to user'
    redirect_to polymorphic_path(instance)
  end

  def collection_export_xlsx
    authorize(controller_class)

    sql = %(
    SELECT
      users.id AS id,
      users.first_name AS first_name,
      users.last_name AS last_name,
      users.email AS email,
      users.role AS role,
      users.notes AS notes
    FROM
      users
    WHERE
      users.archived_at IS NULL
    ORDER BY
      users.last_name ASC
  )

    @results = ActiveRecord::Base.connection.select_all(sql)
    file_name = controller_class_instances
    filepath = "#{Rails.root}/tmp/#{file_name}.xlsx"

    File.open(filepath, 'wb') do |f|
      f.write render_to_string(handlers: [:axlsx], formats: [:xlsx], template: 'xlsx/reports')
    end

    render xlsx: 'reports', handlers: [:axlsx], formats: [:xlsx], template: 'xlsx/reports', filename: "#{file_name}_#{DateTime.now.strftime('%Y-%m-%d_%k-%M-%S')}.xlsx"
  end

  private

  def create_params
    params.permit(
      :archived_at,
      :confirmed_at,
      :email,
      :first_name,
      :middle_name,
      :last_name,
      :notes,
      :password,
      :password_confirmation,
    )
  end

  def update_params
    params.permit(
      :archived_at,
      :confirmed_at,
      :email,
      :first_name,
      :last_name,
      :middle_name,
      :notes,
    )
  end
end
