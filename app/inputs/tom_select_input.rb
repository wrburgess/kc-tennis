class TomSelectInput < SimpleForm::Inputs::Base
  def input(wrapper_options = nil)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
    prompt = options[:prompt] || nil
    options_for_select = options[:options_for_select]
    multiple = options[:multiple] || false
    autocomplete = options[:autocomplete] || 'off'

    @builder.select(attribute_name, options_for_select, { prompt:, multiple:, autocomplete: }.merge(merged_input_options))
  end
end
