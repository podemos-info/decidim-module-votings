# frozen_string_literal: true

module Decidim
  module Votings
    # Exposes votings to users.
    class VotingsController < Decidim::Votings::ApplicationController
      include FilterResource

      helper_method :voting
      helper Decidim::PaginateHelper

      def show; end

      def index
        @votings = Voting.all
      end

      private

      def voting
        @voting ||= Voting.find(params[:id])
      end
    end
  end
end
