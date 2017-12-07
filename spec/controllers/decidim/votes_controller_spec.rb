# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Votings
    describe VotesController, type: :controller do
      routes {Decidim::Votings::Engine.routes}

      let(:user) {create(:user, :confirmed, organization: feature.organization)}

      let(:feature) {create :voting_feature, :participatory_process}

      let(:params) do
        {
          feature_id: feature.id,
          participatory_process_slug: feature.participatory_space.slug
        }
      end

      before do
        request.env["decidim.current_organization"] = feature.organization
        request.env["decidim.current_feature"] = feature
        sign_in user
      end

      context 'show' do
        context 'voting started' do
          let!(:voting) {create(:voting, feature: feature)}
          context "with valid key" do
            it 'shows voting info' do
              get :show, params: params.merge({ voting_id: voting.id, key: voting.get_hash})
              expect(response).to have_http_status(200)
            end
          end
          context "with invalid key" do
            it 'shows voting info' do
              get :show, params: params.merge({ voting_id: voting.id, key: 'fakekey'})
              expect(response).to have_http_status(200)
            end
          end
        end
        context 'voting not started' do
          let!(:voting) {create(:voting, :not_started, feature: feature)}
          context "with valid key" do
            it 'shows voting info' do
              get :show, params: params.merge({ voting_id: voting.id, key: voting.get_hash})
              expect(response).to have_http_status(200)
            end
          end
          context "with invalid key" do
            it 'shows voting info' do
              expect do
                get :show, params: params.merge({ voting_id: voting.id, key: 'fakekey'})
              end.to raise_error(ActionController::RoutingError)
            end
          end
        end
      end
    end
  end
end
