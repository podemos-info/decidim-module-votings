# frozen_string_literal: true

require 'decidim/faker/localized'
require 'decidim/dev'

FactoryBot.define do
  factory :voting_feature, parent: :feature do
    name { Decidim::Features::Namer.new(participatory_space.organization.available_locales, :votings).i18n_name }
    manifest_name :votings
    participatory_space { create(:participatory_process, :with_steps, organization: organization) }
  end

  factory :voting, class: Decidim::Votings::Voting do
    title { Decidim::Faker::Localized.sentence(3) }
    description { Decidim::Faker::Localized.wrapped('<p>', '</p>') { Decidim::Faker::Localized.sentence(4) } }
    status 'simulation'
    feature { create(:voting_feature) }
  end
end
