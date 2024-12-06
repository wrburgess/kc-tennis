class Admin::HeaderForIndex::Component < ApplicationComponent
  def initialize(instance:, new_button: false, upload_new_button: false, upload_file_button: false, export_xlsx_button: false)
    @instance = instance
    @new_button = new_button
    @upload_new_button = upload_new_button
    @upload_file_button = upload_file_button
    @export_xlsx_button = export_xlsx_button
  end

  def headline
    @instance.class.name.titleize.pluralize
  end

  def render?
    true
  end
end
