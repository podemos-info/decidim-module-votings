# frozen_string_literal: true

require "decidim/votings/admin"
require "decidim/votings/admin_engine"
require "decidim/votings/engine"
require "decidim/votings/vote_confirmation"
require "decidim/votings/vote_confirmation_engine"
require "decidim/votings/component"

module Decidim
  module Votings
    include ActiveSupport::Configurable
    # Number of collaborations shown per page in administrator
    # dashboard
    config_accessor :votings_shown_per_page do
      15
    end
  end
end
