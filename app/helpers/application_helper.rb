module ApplicationHelper
  def default_date_format(date_value)
    if date_value.respond_to?(:strftime)
      date_value.strftime("%b %e, %Y")
    else
      date_value
    end
  end
end
