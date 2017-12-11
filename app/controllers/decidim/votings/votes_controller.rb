# frozen_string_literal: true

module Decidim
  module Votings
    # Exposes votings to users.
    class VotesController < Decidim::Votings::ApplicationController
      helper_method :voting

      def show
        unless voting.started?
          if params[:key] != voting.simulation_key
            raise ActionController::RoutingError, "Not Found"
          end
        end
        authorize! :vote, voting
      end

      def token
        if voting.finished?
          flash[:error] = I18n.t("decidim.votings.messages.finished")
          render(plain: destination_url(voting), status: :gone) && return
        end
        unless voting.in_census_limit? current_user
          flash[:error] = I18n.t("decidim.votings.messages.census_limit")
          render(plain: destination_url(voting), status: :gone) && return
        end
        unless voting.in_scope? current_user
          flash[:error] = I18n.t("decidim.votings.messages.invalid_scope")
          render(plain: destination_url(voting), status: :gone) && return
        end
        attributes = { voting: voting, user: current_user }
        attributes[:simulated_code] = voting.simulated_code if voting.vote_class == Decidim::Votings::SimulatedVote
        vote = voting.vote_class.find_or_create_by(attributes)
        vote.store_voter_identifier

        render plain: vote.token, status: :ok
      end

      private

      def voting
        @voting ||= Voting.find(params[:voting_id])
      end

      def destination_url(voting)
        voting.started? ? voting_url(voting.id) : voting_url(voting.id, key: voting.simulation_key)
      end
    end
  end
end
