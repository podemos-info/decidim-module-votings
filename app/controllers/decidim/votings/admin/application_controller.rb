# frozen_string_literal: true

module Decidim
  module Votings
    module Admin
      # This controller is the abstract class from which all other controllers of
      # this engine inherit.
      #
      # Note that it inherits from `Decidim::Features::BaseController`, which
      # override its layout and provide all kinds of useful methods.
      class ApplicationController < Decidim::Admin::Features::BaseController
        helper_method :votings, :voting

        def votings
          @votings ||= Voting
                       .for_feature(current_feature)
                       .page(params[:page])
                       .per(Decidim::Votings.votings_shown_per_page)
        end

        def voting
          @voting ||= votings.find(params[:id])
        end
      end
    end
  end
end
