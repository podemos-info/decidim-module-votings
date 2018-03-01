# frozen_string_literal: true

module Decidim
  module Votings
    module Admin
      # Encapsulates a form to hold the information for a voting that can be
      # overriden on an scope basis
      class ElectoralDistrictForm < Decidim::Form
        attribute :decidim_scope_id, Integer
        attribute :voting_identifier, String
        attribute :delete, Boolean, default: false

        validates :scope, presence: true
        validates :voting_identifier, presence: true

        def scope
          @scope ||= Decidim::Scope.find_by(id: decidim_scope_id)
        end
      end
    end
  end
end
