# frozen_string_literal: true

require "spec_helper"
require "cancan/matchers"

describe Decidim::Votings::Abilities::CurrentUserAbility do
  subject { described_class.new(user, feature_settings: feature_settings) }

  let(:feature_settings) { {} }
  let(:user_annual_accumulated) { 0 }
  let(:remote_authorization) { true }
  let(:remote_authorization_url) { "http://example.org" }
  let(:voting) { create(:voting) }
  let(:user) { create(:user, organization: voting.feature.organization) }

  before do
    expect(feature_settings).to receive(:remote_authorization?)
      .at_most(:once)
      .and_return(remote_authorization)
  end

  context "when voting finished" do
    let(:voting) { create(:voting, start_date: Time.zone.now - 2.days, end_date: Time.zone.now - 1.day) }

    it "does not allow to vote" do
      expect(subject).not_to be_able_to(:vote, voting)
    end
  end
  context "with remote authorization enabled" do
    let(:remote_authorization) { true }

    context "when server returns 201" do
      before do
        stub_request(:post, "http://example.org/authorizations").to_return(status: 201, body: "", headers: {})
      end

      it "allows to vote" do
        expect(feature_settings).to receive(:remote_authorization_url)
          .at_most(:once)
          .and_return(remote_authorization_url)
        expect(subject).to be_able_to(:vote, voting)
      end
    end
    context "when server returns 401" do
      before do
        stub_request(:post, "http://example.org/authorizations").to_return(status: 401, body: "", headers: {})
      end

      it "does not allow to vote" do
        expect(feature_settings).to receive(:remote_authorization_url)
          .at_most(:once)
          .and_return(remote_authorization_url)
        expect(subject).not_to be_able_to(:vote, voting)
      end
    end
  end

  context "with remote authorization disabled" do
    let(:remote_authorization) { false }

    it "allows to vote" do
      expect(subject).to be_able_to(:vote, voting)
    end
  end
end
