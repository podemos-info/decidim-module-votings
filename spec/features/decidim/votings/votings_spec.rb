# frozen_string_literal: true

require "spec_helper"

describe "Votings pages", type: :feature do
  include_context "with a feature"
  let(:manifest_name) { "votings" }

  let!(:votings) { create_list(:voting, 3, :n_votes, feature: feature) }
  let!(:voting) { Decidim::Votings::Voting.where(feature: feature).first }
  let!(:user) { create :user, :confirmed, organization: organization }

  context "when he user is logged in" do
    before do
      login_as user, scope: :user
    end

    context "when visiting detail" do
      it "has button for voting" do
        visit_feature
        click_link voting.title["en"]
        expect(page).to have_link("Vote")
      end

      it "has a message about voting system used" do
        visit_feature
        click_link voting.title["en"]
        expect(page).to have_content("Agora")
      end

      context "when user has voted" do
        let!(:vote) { create :vote, :confirmed, voting: voting, user: user }

        it "has a message informing" do
          visit_feature
          click_link voting.title["en"]
          expect(page).to have_content("already voted")
        end
      end
    end
  end
end
