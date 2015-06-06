# "public charts" are charts comprised of static measures such as those set by
# CMS. They are not customizable for a client, thus they are not backed by
# dynamic data, e.g. in the database.
class PublicChartsController < ApplicationController
  SELECTED_DATA_TYPES = %w[provider_id context]

  def show
    SELECTED_DATA_TYPES.each { |type| persist_selected(type) }

    @custom_feedback_bar = true

    @node = find_node(
      providers: relevant_providers_relation,
      selected_provider: selected_provider,
    )

    @embedded_node = find_node(
      providers: selected_provider_relation,
      selected_provider: selected_provider,
    )

    @provider_compare_presenter = Providers::ProviderComparePresenter.new(
      selected_provider,
      current_user.selected_context,
    )

    @selected_provider_presenter = Providers::SelectedProviderPresenter.new(
      selected_provider,
      @node,
      @embedded_node,
    )

    @conversation_presenter = Conversations::ConversationPresenter.new(
      current_user,
      @node.id_component,
    )

    respond_to do |format|
      format.html
      format.json { render json: @node.data }
    end
  end

  private

  def selected_provider
    current_user.selected_provider
  end

  def relevant_providers_relation
    selected_provider.providers_relation(current_user.selected_context)
  end

  def selected_provider_relation
    Provider.where(
      cms_provider_id: selected_provider.cms_provider_id,
    )
  end

  def persist_selected(item)
    return unless send("#{item}")
    current_user.update_attribute(
      "selected_#{item}",
      send("#{item}"),
    )
  end

  def provider_id
    params.fetch(:provider_id, nil)
  end

  def context
    params.fetch(:context, nil)
  end

  def find_node(providers:, selected_provider:)
    PUBLIC_CHARTS_TREE.find_node(
      params.fetch(:id),
      providers: providers,
      selected_provider: selected_provider,
    )
  end
end
