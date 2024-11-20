class LinksController < ApplicationController
  include Pagy::Backend

  before_action :authenticate_user!

  def index
    authorize(controller_class)
    @q = controller_class.includes(:titles).ransack(index_archivable_params)
    @q.sorts = ['name asc', 'created_at desc'] if @q.sorts.empty?
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
    instance.destroy

    instance.log(user: current_user, operation: action_name)
    flash[:danger] = "#{instance.class_name_title} successfully deleted"
    redirect_to polymorphic_path(controller_class)
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
    file_name = instance.class_name_plural
    filepath = "#{Rails.root}/tmp/#{file_name}.xlsx"

    File.open(filepath, 'wb') do |f|
      f.write render_to_string(handlers: [:axlsx], formats: [:xlsx], template: 'xlsx/reports')
    end

    render xlsx: 'reports', handlers: [:axlsx], formats: [:xlsx], template: 'xlsx/reports', filename: "#{file_name}_#{DateTime.now.strftime('%Y-%m-%d_%k-%M-%S')}.xlsx"
  end

  private

  def create_params
    params.permit(
      :notes,
      :secret_code,
      :url,
      :url_type,
      :video_type,
    )
  end

  def update_params
    params.permit(
      :notes,
      :secret_code,
      :url,
      :url_type,
      :video_type,
    )
  end
end
