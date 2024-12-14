module ApplicationHelper
  include Pagy::Frontend

  def file_name_with_timestamp(file_name:, file_extension:)
    "#{file_name}_#{DateTime.now.strftime('%Y-%m-%d_%H-%M-%S')}.#{file_extension}"
  end

  def default_date_format(date_value)
    if date_value.respond_to?(:strftime)
      date_value.strftime('%b %e, %Y')
    else
      date_value
    end
  end

  def selector_date_format(date_value)
    if date_value.respond_to?(:strftime)
      date_value.strftime('%Y-%m-%d')
    else
      date_value
    end
  end
end
