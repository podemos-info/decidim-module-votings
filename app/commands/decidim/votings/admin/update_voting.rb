# frozen_string_literal: true

module Decidim
  module Votings
    module Admin
      # This command is executed when the user changes a Voting from
      # the admin panel.
      class UpdateVoting < VotingCommand
        # Initializes an UpdateProject Command.
        #
        # form - The form from which to get the data.
        # voting - The current instance of the voting to be updated.
        def initialize(form, voting)
          super(form)
          @voting = voting
        end

        # Updates the voting if valid.
        #
        # Broadcasts :ok if successful, :invalid otherwise.
        def call
          return broadcast(:invalid) if form.invalid?

          update_voting
          broadcast(:ok)
        end

        private

        attr_reader :voting

        def update_voting
          voting.update_attributes!(
            title: form.title,
            description: form.description,
            image: form.image,
            start_date: form.start_date,
            end_date: form.end_date,
            decidim_scope_id: form.decidim_scope_id,
            importance: form.importance,
            census_date_limit: form.census_date_limit,
            status: form.status,
            voting_system: form.voting_system,
            voting_url: form.voting_url
          )
        end
      end
    end
  end
end
