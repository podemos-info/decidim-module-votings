# frozen_string_literal: true

require "decidim/faker/localized"
require "decidim/dev"

FactoryBot.define do
  factory :voting_feature, parent: :feature do
    name { Decidim::Features::Namer.new(participatory_space.organization.available_locales, :votings).i18n_name }
    manifest_name :votings
    participatory_space { create(:participatory_process, :with_steps, organization: organization) }

    trait :participatory_process do
      participatory_space do
        create(:participatory_process, :with_steps, organization: organization)
      end
    end
  end
end

FactoryBot.define do
  factory :voting, class: Decidim::Votings::Voting do
    title { Decidim::Faker::Localized.sentence(3) }
    description { Decidim::Faker::Localized.wrapped("<p>", "</p>") { Decidim::Faker::Localized.sentence(4) } }
    simulation_code 0
    feature { create(:voting_feature) }
    start_date { DateTime.current - 2.days }
    end_date { DateTime.current + 2.days }
    census_date_limit { DateTime.current + 2.days }

    trait :n_votes do
      voting_system { "nVotes" }
      voting_domain_name { "example.org" }
      voting_identifier { 666 }
      shared_key { "SHARED_KEY" }
    end

    trait :not_started do
      start_date { DateTime.current + 1.day }
    end

    trait :finished do
      end_date { DateTime.current - 1.day }
    end
  end
end
