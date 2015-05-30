require 'rails_helper'

RSpec.describe PublicChartsController do
  let(:current_user) do
    create(User, :authenticatable, :confirmed, :with_associations)
  end

  before do
    sign_in current_user
  end

  describe 'GET show' do
    let(:measure_id) { 'heart-failure-readmission' }
    let(:node_id) do
      "payment-programs/hospital-readmissions-reduction-program/#{measure_id}"
    end
    let(:selected_provider_presenter) do
      double('Providers::SelectedProviderPresenter')
    end

    before do
      allow(Providers::SelectedProviderPresenter).to receive(:new)
        .and_return(selected_provider_presenter)
      allow(selected_provider_presenter).to receive(:value).and_return([])
      allow(selected_provider_presenter).to receive(:cms_rank).and_return([])
      get :show, id: node_id
    end

    describe 'generate a fixture with conversations' do
      let!(:conversation) do
        create(
          Conversation,
          :with_associations,
          id: 99,
          measure_id: measure_id,
          author: current_user,
          provider: current_user.selected_provider,
        )
      end

      save_fixture do
        get :show, id: node_id
        expect(response).to be_success
      end
    end

    describe 'metrics navigation' do
      subject { response.body }
      let(:measures_nav_container) { '#measures_nav_container' }

      context 'for measures' do
        it 'shows parent' do
          is_expected.to have_css(
            measures_nav_container,
            text: 'Hospital Readmissions Reduction Program',
          )
        end

        it 'shows sibling measures' do
          is_expected.to have_css(
            measures_nav_container,
            text: 'Acute Myocardial Infarction Readmission',
          )
        end
      end

      context 'for non-measures' do
        let(:node_id) do
          %w[
            payment-programs
            hospital-consumer-assessment-of-healthcare-providers-and-systems
          ].join('/')
        end

        it 'shows the current node' do
          is_expected.to have_css(
            measures_nav_container,
            text: 'Hospital Consumer Assessment of ' \
                  'Healthcare Providers and Systems',
          )
        end

        it 'does not show sibling nodes' do
          is_expected.not_to have_css(
            measures_nav_container,
            text: 'Heart Failure Readmission',
          )
        end

        it 'shows child nodes' do
          is_expected.to have_css(
            measures_nav_container,
            text: 'Communication with Nurses',
          )
        end
      end
    end

    context 'with parameters' do
      let(:provider) { create(Provider) }
      let(:node_id) { 'payment-programs' }
      let(:get_params) { {} }

      before do
        get :show, { id: node_id }.merge(get_params)
        current_user.reload
      end

      context 'with selected provider id' do
        let(:get_params) { { provider_id: provider.id } }

        it 'persists selected provider' do
          expect(current_user.selected_provider).to eq provider
        end
      end

      context 'with comparison context' do
        let(:get_params) { { context: 'state' } }

        it 'persists selected context' do
          expect(current_user.selected_context).to eq 'state'
        end
      end
    end
  end
end
