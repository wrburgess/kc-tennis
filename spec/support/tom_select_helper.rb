module TomSelectHelper
  def fill_in_tom_select_field(input_selector:, text_value:)
    # Find the TomSelect wrapper
    wrapper = find("#{input_selector} + .ts-wrapper")
    wrapper.click

    # Wait for dropdown and select option
    within('.ts-dropdown-content') do
      find('.option', text: text_value, wait: 5, exact_text: true).click
    end
  end
end
