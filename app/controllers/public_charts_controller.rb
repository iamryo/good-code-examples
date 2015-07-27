# "public charts" are charts comprised of static measures such as those set by
# CMS. They are not customizable for a client, thus they are not backed by
# dynamic data, e.g. in the database.
class PublicChartsController < ApplicationController
  SELECTED_DATA_TYPES = %w[provider_id context]
  before_action :set_persisted_selections,
                :set_provider_compare_presenter,
                :set_selected_provider_presenter,
                :set_conversation_presenter,
                only: [:show]

  def show
    @custom_feedback_bar = true

    respond_to do |format|
      format.html
      format.json { render json: @node.data }
    end
  end

  private

  def set_persisted_selections
    SELECTED_DATA_TYPES.each { |type| persist_selected(type) }
    set_node
    set_embedded_node
  end

  def set_node
    @node = find_node(
      providers: relevant_providers_relation,
      selected_provider: selected_provider,
    )
  end

  def set_embedded_node
    @embedded_node = find_node(
      providers: selected_provider_relation,
      selected_provider: selected_provider,
    )
  end

  def set_provider_compare_presenter
    @provider_compare_presenter = Providers::ProviderComparePresenter.new(
      selected_provider,
      current_user.selected_context,
    )
  end

  def set_selected_provider_presenter
    @selected_provider_presenter = Providers::SelectedProviderPresenter.new(
      selected_provider,
      @node,
      @embedded_node,
    )
  end

  def set_conversation_presenter
    @conversation_presenter = Conversations::ConversationPresenter.new(
      current_user,
      @node.id_component,
    )
  end

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
