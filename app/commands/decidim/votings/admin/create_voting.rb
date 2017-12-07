# frozen_string_literal: true

module Decidim
  module Votings
    module Admin
      # This command is executed when the user creates a Voting from
      # the admin panel.
      class CreateVoting < VotingCommand
        # Creates the project if valid.
        #
        # Broadcasts :ok if successful, :invalid otherwise.
        def call
          return broadcast(:invalid) if form.invalid?
          create_voting
          broadcast(:ok)
        end

        private

        def create_voting
          Voting.create(
            feature: form.current_feature,
            title: form.title,
            description: form.description,
            image: form.image,
            start_date: form.start_date,
            end_date: form.end_date,
            scope: form.scope,
            importance: form.importance,
            census_date_limit: form.census_date_limit,
            status: form.status,
            voting_system: 'nVotes',
            voting_domain_name: form.voting_domain_name,
            voting_identifier: form.voting_identifier,
            shared_key: form.shared_key
          )
        end
      end
    end
  end
end
