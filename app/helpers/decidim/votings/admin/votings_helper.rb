# frozen_string_literal: true

module Decidim
  module Votings
    # Helper methods for votings.
    module Admin
      module VotingsHelper
        def scope_type_options(selected = nil)
          options_for_select(Decidim::ScopeType.all.map { |scope_type| [translated_attribute(scope_type.name), scope_type.id] },
                             selected: selected)
        end

        def scope_options(selected = nil)
          scope_type = selected.present? ? Decidim::Scope.find(selected).scope_type : Decidim::ScopeType.first
          # unable to do scope_type.scopes because there is a bug in decidim
          relation = Decidim::Scope.where(scope_type_id: scope_type)
          options_for_select(relation.map { |scope| [translated_attribute(scope.name), scope.id] },
                             selected: selected)
        end

        def voting_statuses_options
          Decidim::Votings::Voting.statuses.keys.map { |status| [I18n.t(status, scope: "activemodel.attributes.voting.statuses"), status] }
        end

        def link_to_add_electoral_district(label, form)
          form_content = form.fields_for :electoral_districts, ElectoralDistrictForm.new do |builder|
            render "decidim/votings/admin/votings/electoral_district_fields", builder: builder
          end

          link_to label, "#", class: "add-electoral-district", data: { "form-content" => form_content.html_safe }
        end
      end
    end
  end
end
