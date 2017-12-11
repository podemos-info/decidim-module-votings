# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Votings
    describe VotingsController, type: :controller do
      routes { Decidim::Votings::Engine.routes }

      let(:user) { create(:user, :confirmed, organization: feature.organization) }

      let(:feature) { create :voting_feature, :participatory_process }

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

      context "index" do
        context "one voting" do
          let!(:voting) { create(:voting, feature: feature) }
          let(:path) do
            EngineRouter
              .main_proxy(feature)
              .voting_path(voting)
          end

          it "has an element" do
            get :index, params: params
            expect(assigns(:votings)).not_to be_empty
          end
        end

        context "one voting not open" do
          let!(:voting) { create(:voting, :not_started, feature: feature) }
          let(:path) do
            EngineRouter
              .main_proxy(feature)
              .voting_path(voting)
          end

          it "has no content" do
            get :index, params: params
            expect(assigns(:votings)).to be_empty
          end
        end

        context "several votings" do
          let!(:votings) { create_list(:voting, 2, feature: feature) }

          it "redirects to the voting page" do
            get :index, params: params
            expect(assigns(:votings).count).to eq 2
          end
        end
      end
      context "show" do
        context "voting started" do
          let!(:voting) { create(:voting, feature: feature) }

          context "with valid key" do
            it "shows voting info" do
              get :show, params: params.merge(id: voting.id, key: voting.get_hash)
              expect(response).to have_http_status(200)
            end
          end
          context "with invalid key" do
            it "shows voting info" do
              get :show, params: params.merge(id: voting.id, key: "fakekey")
              expect(response).to have_http_status(200)
            end
          end
        end
        context "voting not started" do
          let!(:voting) { create(:voting, :not_started, feature: feature) }

          context "with valid key" do
            it "shows voting info" do
              get :show, params: params.merge(id: voting.id, key: voting.get_hash)
              expect(response).to have_http_status(200)
            end
          end
          context "with invalid key" do
            it "shows voting info" do
              expect do
                get :show, params: params.merge(id: voting.id, key: "fakekey")
              end.to raise_error(ActionController::RoutingError)
            end
          end
        end
      end
    end
  end
end
