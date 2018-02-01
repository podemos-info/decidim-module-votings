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

        attribute :start_date, Decidim::Attributes::TimeWithZone
        attribute :end_date, Decidim::Attributes::TimeWithZone
        attribute :image, String
        attribute :scopes_enabled, Boolean
        attribute :decidim_scope_id, Integer
        attribute :importance, Integer
        attribute :census_date_limit, Decidim::Attributes::TimeWithZone
        attribute :voting_system, String
        attribute :voting_domain_name, String
        attribute :voting_identifier, String
        attribute :shared_key, String
        attribute :simulation_code, Integer
        attribute :can_change_shared_key, Boolean
        attribute :change_shared_key, Boolean

        validates :title, translatable_presence: true
        validates :description, translatable_presence: true
        validates :image, file_size: { less_than_or_equal_to: ->(_image) { Decidim.maximum_attachment_size } }
        validates :importance, numericality: { only_integer: true }
        validates :start_date, presence: true, date: { before: :end_date }
        validates :end_date, presence: true, date: { after: :start_date }
        validates :simulation_code, numericality: { only_integer: true }

        validates :current_feature, presence: true
        validates :scope, presence: true, if: ->(form) { form.decidim_scope_id.present? }

        validate :voting_range_in_process_bounds

        def map_model(voting)
          self.scopes_enabled = voting.scope.present?
          self.can_change_shared_key = voting.can_change_shared_key?
          self.change_shared_key = false
        end

        def process_scope
          current_feature.participatory_space.scope
        end

        def scope
          return unless current_feature
          return process_scope if !scopes_enabled || decidim_scope_id.blank?
          @scope ||= (process_scope.try(:descendants) || current_feature.scopes).where(id: decidim_scope_id).first
        end

        def voting_system
          "nVotes"
        end

        private

        # Validates that start_date and end_date are inside participatory process bounds.
        def voting_range_in_process_bounds
          return unless steps?

          unless included_in_steps?(start_date)
            errors.add(:start_date, I18n.t("activemodel.errors.voting.voting_range.outside_process_range"))
          end

          unless included_in_steps?(end_date)
            errors.add(:end_date, I18n.t("activemodel.errors.voting.voting_range.outside_process_range"))
          end
        end

        def included_in_steps?(date_time)
          return true if date_time.blank?
          steps_containing_date = steps.select do |step|
            date_time.between?(step.start_date, step.end_date)
          end
          steps.empty? || steps_containing_date.any?
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
