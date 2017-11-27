# frozen_string_literal: true

module Decidim
  module Votings
    module Admin
      # Exposes the initiative type text search so users can choose a type writing its name.
      class VotingsScopesController < Decidim::ApplicationController
        helper Decidim::Votings::Admin::VotingsHelper
        helper_method :scopes

        # GET /initiative_type_scopes/search
        def search
          authorize! :search, Decidim::Scope
          render layout: false
        end

        private

        def scopes
          @scopes ||= Decidim::Scope.where(scope_type: params[:type_id])
        end
      end
    end
  end
end
