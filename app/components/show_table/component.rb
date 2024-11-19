class ShowTable::Component < ApplicationComponent
  renders_many :rows, ->(name:, value:) { RowComponent.new(name: name, value: value) }

  def initialize(title: nil)
    @title = title
  end

  def render?
    true
  end

  class RowComponent < ApplicationComponent
    attr_reader :name, :value

    def initialize(name:, value:)
      @name = name
      @value = value
    end
  end
end
