class PageWrapper::Component < ApplicationComponent
  def initialize(instance:, controller:, action:)
    @instance = instance
    @controller = controller
    @action = action
  end

  def controller_name_dasherized
    @instance.model_name.plural.downcase.dasherize
  end

  def render?
    true
  end
end
