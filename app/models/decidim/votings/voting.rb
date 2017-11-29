# frozen_string_literal: true

module Decidim
  module Votings
    # Model for collaboration campaigns defined inside a
    # participatory space.
    class Voting < Decidim::Votings::ApplicationRecord
      include Decidim::Resourceable
      include Decidim::HasFeature
      include Decidim::Followable
      include Decidim::HasScope

      feature_manifest_name 'votings'

      enum status: { simulation: 0, live: 1 }

      mount_uploader :image, Decidim::ImageUploader

      store_accessor :system_configuration, :voting_url, :voting_identifier, :shared_key

      validates :image, file_size: { less_than_or_equal_to: ->(_attachment) { Decidim.maximum_attachment_size } }

      scope :for_feature, ->(feature) { where(feature: feature) }
    end
  end
end
