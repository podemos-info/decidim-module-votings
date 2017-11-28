# frozen_string_literal: true

module Decidim
  module Votings
    module Abilities
      class CurrentUserAbility
        include CanCan::Ability

        attr_reader :user, :context

        def initialize(user, context)
          return unless user

          @user = user
          @context = context

          can :search, Decidim::Scope
        end

        private

        def current_settings
          @context.fetch(:current_settings, nil)
        end
      end
    end
  end
end
