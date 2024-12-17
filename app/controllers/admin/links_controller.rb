class Admin::LinksController < AdminController
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
    @instance = controller_class.find(params[:id])
  end

  def new
    authorize(controller_class)
    @instance = controller_class.new
  end

  def create
    authorize(controller_class)
    instance = controller_class.create(create_params)

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

    instance.log(user: current_user, operation: action_name, meta: params.to_json, original_data: original_instance.attributes.to_json)
    flash[:success] = "#{instance.class_name_title} successfully updated"
    redirect_to polymorphic_path([:admin, instance])
  end

  def destroy
    authorize(controller_class)
    instance = controller_class.find(params[:id])

    instance.log(user: current_user, operation: SystemOperations::DELETED)
    flash[:danger] = "#{instance.class_name_title} successfully deleted"
    instance.destroy

    redirect_to polymorphic_path([:admin, controller_class])
  end

  def archive
    instance = controller_class.find(params[:id])
    authorize(controller_class)
    instance.archive

    instance.log(user: current_user, operation: action_name)
    flash[:danger] = "#{instance.class_name_title} archived"
    redirect_to polymorphic_path([:admin, controller_class])
  end

  def unarchive
    authorize(controller_class)
    instance = controller_class.find(params[:id])
    instance.unarchive

    instance.log(user: current_user, operation: SystemOperations::UNARCHIVED)
    flash[:success] = "#{instance.class_name_title} successfully unarchived"
    redirect_to polymorphic_path([:admin, instance])
  end

  def collection_export_xlsx
    authorize(controller_class)

    sql = %(
      SELECT
        *
      FROM
        links
      WHERE
        links.archived_at IS NULL
      ORDER BY
        links.created_at ASC
    )

    @results = ActiveRecord::Base.connection.select_all(sql)
    file_name = controller_class_plural
    filepath = "#{Rails.root}/tmp/#{file_name}.xlsx"

    File.open(filepath, 'wb') do |f|
      f.write render_to_string(handlers: [:axlsx], formats: [:xlsx], template: 'xlsx/reports', layout: false)
    end

    render(xlsx: 'reports', handlers: [:axlsx], formats: [:xlsx], template: 'xlsx/reports', filename: helpers.file_name_with_timestamp(file_name:, file_extension: 'xlsx'), layout: false)
  end

  def member_export_xlsx
    authorize(controller_class)
    instance = controller_class.find(params[:id])

    sql = %(
      SELECT
        *
      FROM
        links
      WHERE
        links.id = #{instance.id}
      ORDER BY
        links.created_at ASC
    )

    @results = ActiveRecord::Base.connection.select_all(sql)
    file_name = instance.class_name_singular
    filepath = "#{Rails.root}/tmp/#{file_name}.xlsx"

    File.open(filepath, 'wb') do |f|
      f.write render_to_string(handlers: [:axlsx], formats: [:xlsx], template: 'xlsx/reports', layout: false)
    end

    render(xlsx: 'reports', handlers: [:axlsx], formats: [:xlsx], template: 'xlsx/reports', filename: "#{file_name}_#{DateTime.now.strftime('%Y-%m-%d_%H-%M-%S')}.xlsx", layout: false)
  end

  private

  def create_params
    params.require(:link).permit(
      :notes,
      :secure_code,
      :url,
      :url_type,
      :video_type,
    )
  end

  def update_params
    params.require(:link).permit(
      :notes,
      :secure_code,
      :url,
      :url_type,
      :video_type,
    )
  end
end
