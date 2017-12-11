# frozen_string_literal: true

require "rails"
require "active_support/all"

require "decidim/core"

module Decidim
  module Votings
    # Decidim's <EngineName> Rails Engine.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Votings

      routes do
        resources :votings, only: [:index, :show] do
          get :token
          resource :vote, only: [:show] do
            get :token
          end
        end

        root to: "votings#index"
      end

      initializer "decidim_votings.assets" do |app|
        app.config.assets.precompile += %w(decidim_votings_manifest.js decidim_votings_manifest.css)
      end

      initializer "decidim_votings.inject_abilities_to_user" do |_app|
        Decidim.configure do |config|
          config.abilities += ["Decidim::Votings::Abilities::CurrentUserAbility"]
        end
      end
    end
  end
end
