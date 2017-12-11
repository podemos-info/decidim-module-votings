# frozen_string_literal: true

module Decidim
  module Votings
    # Exposes votings to users.
    class VotingsController < Decidim::Votings::ApplicationController
      include FilterResource

      helper_method :voting
      helper Decidim::PaginateHelper

      def show
        unless voting.started?
          if params[:key] != voting.get_hash
            raise ActionController::RoutingError, "Not Found"
          end
        end
      end

      def index
        @votings = Voting.for_feature(current_feature).active
      end

      private

      def voting
        @voting ||= Voting.find(params[:id])
      end
    end
  end
end
