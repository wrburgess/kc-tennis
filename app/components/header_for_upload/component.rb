class HeaderForUpload::Component < ApplicationComponent
  def initialize(instance:)
    @instance = instance
  end

  def model_name
    @instance.class_name_title
  end

  def render?
    true
  end
end
