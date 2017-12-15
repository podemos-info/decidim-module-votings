# frozen_string_literal: true

Decidim.register_feature(:votings) do |feature|
  feature.engine = Decidim::Votings::Engine
  feature.admin_engine = Decidim::Votings::AdminEngine
  feature.icon = "decidim/votings/icon.svg"

  feature.on(:before_destroy) do |instance|
    # Code executed before removing the feature
  end

  feature.register_resource do |resource|
    resource.model_class_name = "Decidim::Votings::Voting"
    resource.template = "decidim/votings/votings/linked_votings"
  end

  # These actions permissions can be configured in the admin panel
  feature.actions = %w(vote)

  feature.settings(:global) do |settings|
    # Add your global settings
    # Available types: :integer, :boolean
    settings.attribute :remote_authorization_url, type: :string, default: nil
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
