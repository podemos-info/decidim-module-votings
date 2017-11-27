# frozen_string_literal: true

module Decidim
  module Votings
    module Admin
      # This class holds a Form to create/update votings from
      # Decidim's admin panel.
      class VotingForm < Decidim::Form
        include TranslatableAttributes
        include TranslationsHelper

        translatable_attribute :title, String
        translatable_attribute :description, String

        attribute :start_date, Date
        attribute :end_date, Date
        attribute :status, String
        attribute :image, String
        attribute :scope_type_id, Integer
        attribute :decidim_scope_id, Integer
        attribute :importance, Integer
        attribute :census_date_limit, Date
        attribute :voting_system, String
        attribute :voting_url, String

        validates :title, translatable_presence: true
        validates :description, translatable_presence: true
        validates :image, file_size: { less_than_or_equal_to: ->(_image) { Decidim.maximum_attachment_size } }

        validate :voting_range_in_process_bounds

        def map_model(voting)
          self.scope_type_id = voting.scope.try(:scope_type_id) || Decidim::ScopeType.last.id
        end

        private

        # Validates that start_date and end_date are inside participatory process bounds.
        def voting_range_in_process_bounds
          return unless steps?
          return if included_in_steps?(start_date) && included_in_steps?(end_date)

          errors.add(
            :active_until,
            I18n.t(
              'voting.voting_range.outside_process_range',
              scope: 'activemodel.errors'
            )
          )
        end


        def included_in_steps?(date)
          return true if date.blank?
          steps_containing_date = steps.select do |step|
            step_range = step.start_date..step.end_date
            step_range.include? date
          end
          steps_containing_date.any?
        end

        def steps?
          context.current_feature.participatory_space.respond_to? :steps
        end

        def steps
          context.current_feature.participatory_space.steps
        end
      end
    end
  end
end
