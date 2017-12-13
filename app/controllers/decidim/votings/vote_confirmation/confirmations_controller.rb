# frozen_string_literal: true

module Decidim
  module Votings
    module VoteConfirmation
      class ConfirmationsController < Decidim::Votings::VoteConfirmation::ApplicationController
        def confirm
          voter_id = params[:uid]
          render json: { result: "ko" } and return unless voter_id
          vote = Vote.where(voter_identifier: voter_id).first || SimulatedVote.where(voter_identifier: voter_id).first
          vote.confirm! if vote
          render json: { result: "ok" }
        end
      end
    end
  end
end
