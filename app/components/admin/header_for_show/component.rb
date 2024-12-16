class Admin::HeaderForShow::Component < ApplicationComponent
  def initialize(instance:, action:, controller:, delete_button: false, edit_button: false, copy_button: false, download_show_button: false)
    @instance = instance
    @action = action
    @controller = controller
    @delete_button = delete_button
    @edit_button = edit_button
    @copy_button = copy_button
    @download_show_button = download_show_button
  end

  def link_text
    @instance.class_name_title.pluralize
  end

  def path_name
    @instance.class_name_plural
  end

  def headline
    @instance.try(:name) || @instance.try(:id)
  end

  def render?
    true
  end
end
