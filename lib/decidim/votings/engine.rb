# frozen_string_literal: true

require 'rails'
require 'active_support/all'

require 'decidim/core'

module Decidim
  module Votings
    # Decidim's <EngineName> Rails Engine.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Votings

      routes do
        resources :votings, only: %i[index show]

        root to: 'votings#index'
      end

      initializer 'decidim_votings.assets' do |app|
        app.config.assets.precompile += %w[decidim_votings_manifest.js]
      end
    end
  end
end
