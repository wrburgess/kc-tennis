class Admin::NavBar::Component < ApplicationComponent
  renders_many :nav_items, Admin::NavItem::Component
end
