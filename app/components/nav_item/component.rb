class NavItem::Component < ViewComponent::Base
  renders_many :dropdown_items, 'NavDropdownItem::Component'

  def initialize(title:)
    @title = title
  end
end
