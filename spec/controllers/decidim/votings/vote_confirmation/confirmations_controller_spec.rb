# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Votings
    module VoteConfirmation
      describe ConfirmationsController, type: :controller do
        routes { Decidim::Votings::VoteConfirmationEngine.routes }

        let(:user) { create(:user, :confirmed, organization: feature.organization) }

        let(:feature) { create :voting_feature, :participatory_process }

        let(:identifier) { "6036dfb5fb227d22f8728317d572d972f67304c188281cd72319a581502a7ef2" }

        let!(:voting) { create(:voting, feature: feature) }

        before do
          request.env["decidim.current_organization"] = feature.organization
          request.env["decidim.current_feature"] = feature
          sign_in user
        end

        context "when confirming existing vote" do

          context "when vote exists" do
            let!(:vote) { create(:vote, voting: voting, voter_identifier: identifier, user: user) }
            it "confirms the vote" do
              get :confirm, params: { uid: identifier }
              expect(JSON.parse(response.body)['result']).to eq "ok"
              expect(Decidim::Votings::Vote.last.status).to eq "confirmed"
            end
          end

          context "when vote does'nt exist" do
            it "returns ok" do
              get :confirm, params: { uid: identifier }
              expect(JSON.parse(response.body)['result']).to eq "ok"
            end
          end

          context "when param uid does'nt exist" do
            it "returns ok" do
              get :confirm, params: { }
              expect(JSON.parse(response.body)['result']).to eq "ko"
            end
          end

          context "when simulated vote exists" do
            let!(:simulated_vote) { create(:vote, voting: voting, voter_identifier: identifier, user: user) }
            it "confirms the vote" do
              get :confirm, params: { uid: identifier }
              expect(JSON.parse(response.body)['result']).to eq "ok"
              expect(Decidim::Votings::SimulatedVote.last.status).to eq "confirmed"
            end
          end

        end
      end
    end
  end
end
