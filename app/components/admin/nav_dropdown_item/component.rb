class Admin::NavDropdownItem::Component < ApplicationComponent
  def initialize(name:, path:, resource: nil, operation: 'index', external: false)
    @name = name
    @path = path
    @resource = resource
    @operation = operation
    @external = external
  end

  def render?
    return true if @resource.nil?

    Pundit.policy(current_user, @resource).send("#{@operation}?")
  end
end
