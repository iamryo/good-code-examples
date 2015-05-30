# "public charts" are charts comprised of static measures such as those set by
# CMS. They are not customizable for a client, thus they are not backed by
# dynamic data, e.g. in the database.
class PublicChartsController < ApplicationController
  def show
    @custom_feedback_bar = true
    persist_selected_provider
    persist_selected_context

    @node = find_node(
      providers: providers_relation,
      selected_provider: selected_provider_relation,
    )

    @teaser_node = find_node(
      providers: selected_provider_relation,
      selected_provider: selected_provider_relation,
    )

    @provider_compare_presenter = Providers::ProviderComparePresenter.new(
      selected_provider,
      current_user.selected_context,
    )

    @selected_provider_presenter = Providers::SelectedProviderPresenter.new(
      selected_provider,
      @node,
      @teaser_node,
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

  def providers_relation
    selected_provider.providers_relation(current_user.selected_context)
  end

  def selected_provider_relation
    Provider.where(
      socrata_provider_id: [selected_provider].map(&:socrata_provider_id),
    )
  end

  def persist_selected_provider
    return unless params.fetch(:provider_id, nil)
    current_user.update_attribute(
      :selected_provider_id,
      params.fetch(:provider_id),
    )
  end

  def persist_selected_context
    return unless params.fetch(:context, nil)
    current_user.update_attribute(
      :selected_context,
      params.fetch(:context),
    )
  end

  def selected_provider
    current_user.selected_provider
  end

  def find_node(providers:, selected_provider:)
    PUBLIC_CHARTS_TREE.find_node(
      params.fetch(:id),
      providers: providers,
      selected_provider: selected_provider,
    )
  end
end
