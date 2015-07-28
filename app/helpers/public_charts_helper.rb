# Providers helper methods for PublicChartsController's templates
module PublicChartsHelper
  BACK_URL_OPTIONS = {
    true => {
      controller: :data_categories,
      action: :index,
    },
    false => {
      controller: :public_charts,
      action: :show,
    },
  }

  def back_button_options(node)
    back_is_charts_root = node.type == 'measure_source'
    url_options = BACK_URL_OPTIONS.fetch(back_is_charts_root)
                  .merge(only_path: true)
    url_options[:id] = node.parent_id unless back_is_charts_root
    url_options
  end

  def node_link(node, options = {})
    link_to(
      options.fetch(:text_link, nil) || node.title,
      {
        controller: :public_charts,
        action: :show,
        id: node.id,
        only_path: true,
      },
      class: options.fetch(:class_name, nil),
    )
  end

  def value_description_text(node, description_type)
    node.value_description.fetch(description_type, nil)
  end

  def value_amount_with_unit(value)
    return value if value == 'n/a'
    "#{value}%"
  end

  def node_data_value(data)
    data.fetch(:bars).first.fetch(:value).to_f
  end
end
