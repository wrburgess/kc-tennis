class Admin::HeaderForEdit::Component < ApplicationComponent
  def initialize(instance:)
    @instance = instance
  end

  def model_name
    @instance.class_name_title
  end

  def headline
    @instance.try(:name) || @instance.try(:id)
  end

  def render?
    true
  end
end
