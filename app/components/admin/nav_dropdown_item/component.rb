class Admin::NavDropdownItem::Component < ApplicationComponent
  def initialize(name:, path:, resource: nil, operation: 'index')
    @name = name
    @path = path
    @resource = resource
    @operation = operation
  end

  def render?
    return true if @resource.nil?

    Pundit.policy(helpers.current_user, @resource).send("#{@operation}?")
  end
end
