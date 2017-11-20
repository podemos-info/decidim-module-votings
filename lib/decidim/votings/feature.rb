# frozen_string_literal: true

Decidim.register_feature(:votings) do |feature|
  feature.engine = Decidim::Votings::Engine
  feature.icon = "decidim/votings/icon.svg"

  feature.on(:before_destroy) do |instance|
    # Code executed before removing the feature
  end

# These actions permissions can be configured in the admin panel
  feature.actions = %w()

  feature.settings(:global) do |settings|
    # Add your global settings
    # Available types: :integer, :boolean
    # settings.attribute :vote_limit, type: :integer, default: 0
  end

  feature.settings(:step) do |settings|
    # Add your settings per step
  end

# # Register an optional resource that can be referenced from other resources.
# feature.register_resource do |resource|
#   resource.model_class_name = "Decidim::<EngineName>::<ResourceName>"
#   resource.template = "decidim/<engine_name>/<resource_view_folder>/linked_<resource_name_plural>"
# end

  feature.register_stat :some_stat do |features, start_at, end_at|
    # Register some stat number to the application
  end

  feature.seeds do |participatory_space|
    # Define seeds for a specific participatory_space object
  end
end