# frozen_string_literal: true

require "spec_helper"

describe "Explore votings", type: :system do
  include_context "with a feature"
  let(:manifest_name) { "votings" }

  let(:votings_count) { 5 }
  let!(:votings) { create_list(:voting, votings_count, :n_votes, feature: feature) }
  let!(:voting) { Decidim::Votings::Voting.where(feature: feature).first }
  let!(:user) { create :user, :confirmed, organization: organization }

  context "with index" do
    context "when all votings are active" do
      it "shows all votings" do
        visit_feature
        expect(page).to have_selector("article.card", count: votings_count)

        votings.each do |voting|
          expect(page).to have_content(translated(voting.title))
        end
      end
    end

    context "when there are no votings" do
      let!(:votings) { [] }

      it "shows a message" do
        visit_feature
        expect(page).not_to have_selector("article.card")
        expect(page).to have_content("There is no active voting")
      end
    end

    context "when there are votings but all not active" do
      let!(:votings) { create_list(:voting, votings_count, :n_votes, :not_started, feature: feature) }

      it "shows a message" do
        visit_feature
        expect(page).not_to have_selector("article.card")
        expect(page).to have_content("There is no active voting")
      end
    end
  end
  context "with show" do
    context "when he user is logged in" do
      before do
        login_as user, scope: :user
      end

      context "when visiting detail" do
        it "has button for voting" do
          visit_feature
          click_link translated(voting.title)
          expect(page).to have_button("Vote")
        end

        it "has a message about voting system used" do
          visit_feature
          click_link translated(voting.title)
          expect(page).to have_content("Agora")
        end

        context "when user has voted" do
          let!(:vote) { create :vote, :confirmed, voting: voting, user: user }

          it "has a message informing" do
            visit_feature
            click_link translated(voting.title)
            expect(page).to have_content("already voted")
          end
        end
      end
    end
  end
end