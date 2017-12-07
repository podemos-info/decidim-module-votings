# frozen_string_literal: true

require 'spec_helper'

module Decidim
  module Votings
    module Admin
      describe CreateVoting do
        let(:organization) { create(:organization) }
        let(:participatory_process) { create :participatory_process, organization: organization }
        let(:current_feature) { create :voting_feature, participatory_space: participatory_process }

        let(:context) do
          {
            current_organization: organization,
            current_feature: current_feature
          }
        end

        let(:title) { Decidim::Faker::Localized.sentence(3) }
        let(:description) { Decidim::Faker::Localized.sentence(3) }
        let(:image) { Decidim::Dev.test_file('city.jpeg', 'image/jpeg') }
        let(:start_date) { (Date.today + 1.days).strftime('%Y-%m-%d') }
        let(:end_date) { (Date.today + 5.days).strftime('%Y-%m-%d') }
        let(:scope) {create :scope, organization: organization}
        let(:scope_id) {scope.id}
        let(:importance) { ::Faker::Number.number(2).to_i }
        let(:census_date_limit) { Date.today.strftime('%Y-%m-%d') }
        let(:status) { 'simulation' }
        let(:voting_system) { 'nVotes' }
        let(:voting_domain_name) { 'test.org' }
        let(:voting_identifier) {'identifier'}
        let(:shared_key) {'SHARED_KEY'}
        let(:form) do
          double(
            invalid?: invalid,
            title: title,
            description: description,
            image: image,
            start_date: start_date,
            end_date: end_date,
            scopes_enabled: true,
            scope: scope,
            importance: importance,
            census_date_limit: census_date_limit,
            status: status,
            voting_system: voting_system,
            voting_domain_name: voting_domain_name,
            current_feature: current_feature,
            voting_identifier: voting_identifier,
            shared_key: shared_key
          )
        end
        let(:invalid) { false }
        subject { described_class.new(form) }

        context 'when the form is not valid' do
          let(:invalid) { true }

          it 'is not valid' do
            expect { subject.call }.to broadcast(:invalid)
          end
        end

        context 'when everything is ok' do
          let(:project) { Decidim::Votings::Voting.last }

          it 'creates the voting' do
            expect { subject.call }.to change { Decidim::Votings::Voting.count }.by(1)
          end

          it 'sets the feature' do
            subject.call
            expect(project.feature).to eq current_feature
          end

          it 'sets all attributes received from the form' do
            subject.call
            expect(project.title).to eq title
            expect(project.description).to eq description
            expect(project.image.path.split('/').last).to eq 'city.jpeg'
            expect(project.start_date.strftime('%Y-%m-%d')).to eq start_date
            expect(project.end_date.strftime('%Y-%m-%d')).to eq end_date
            expect(project.decidim_scope_id).to eq scope_id
            expect(project.importance).to eq importance
            expect(project.census_date_limit.strftime('%Y-%m-%d')).to eq census_date_limit
            expect(project.status).to eq status
            expect(project.voting_system).to eq voting_system
            expect(project.voting_domain_name).to eq voting_domain_name
          end
        end
      end
    end
  end
end
