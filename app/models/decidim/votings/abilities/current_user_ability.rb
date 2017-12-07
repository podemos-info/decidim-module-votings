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

          can :vote, Voting do |voting|
            !voting.finished? && voting.in_census_limit?(user) && voting.in_scope?(user)
          end

        end

      end
    end
  end
end
