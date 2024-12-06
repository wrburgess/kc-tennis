class Admin::NavBar::Component < ApplicationComponent
  renders_many :nav_items, 'NavItem::Component'
end
