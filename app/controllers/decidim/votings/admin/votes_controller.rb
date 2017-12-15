# frozen_string_literal: true

module Decidim
  module Votings
    module Admin
      class VotesController < Decidim::Votings::Admin::ApplicationController
        def index
          @votes = voting.vote_class.for_voting(voting)
          @votes = @votes.by_simulation_code(voting.simulation_code) unless voting.started?
          render "index", layout: false, formats: [:text]
        end

        private

        def voting
          @voting ||= Voting.find(params[:voting_id])
        end
      end
    end
  end
end
