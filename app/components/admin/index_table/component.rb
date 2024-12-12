class Admin::IndexTable::Component < ApplicationComponent
  renders_many :columns, ->(title, &block) { Admin::IndexTableColumnComponent.new(title, &block) }
  renders_many :batch_action_buttons, Admin::BatchActionButtonComponent
  renders_many :batch_action_modal_buttons, Admin::BatchActionModalButtonComponent

  def initialize(data:, title: nil, batch: false, small_text: false)
    @data = data
    @title = title
    @batch = batch
    @small_text = small_text
  end
end
