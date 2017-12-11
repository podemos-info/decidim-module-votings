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

      feature_manifest_name "votings"

      mount_uploader :image, Decidim::Votings::VotingUploader

      store_accessor :system_configuration, :voting_domain_name, :voting_identifier, :shared_key

      validates :image, file_size: { less_than_or_equal_to: ->(_attachment) { Decidim.maximum_attachment_size } }

      scope :for_feature, ->(feature) { where(feature: feature) }
      scope :active, -> { where("? BETWEEN start_date AND end_date", DateTime.current) }

      def is_active?
        (start_date.to_datetime..end_date.to_datetime).cover? DateTime.current
      end

      def in_census_limit?(user)
        user.created_at < census_date_limit
      end

      def in_scope?(_user)
        true
      end

      def started?
        start_date.to_datetime < DateTime.current
      end

      def finished?
        end_date.to_datetime < DateTime.current
      end

      def vote_class
        started? ? Vote : SimulatedVote
      end

      def get_hash
        Digest::SHA256.hexdigest("#{Rails.application.secrets.secret_key_base}:#{created_at}:#{id}:#{voting_system}")
      end
    end
  end
end
