# frozen_string_literal: true

require "spec_helper"

describe "Admin manages votings", type: :feature, serves_map: true do
  let(:manifest_name) { "votings" }
  let!(:voting) { create :voting, feature: current_feature, voting_system: "nVotes" }

  include_context "when managing a feature as an admin"

  it_behaves_like "manage votings"
end
