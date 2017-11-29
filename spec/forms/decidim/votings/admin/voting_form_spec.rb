# frozen_string_literal: true

require 'spec_helper'

module Decidim
  module Votings
    module Admin
      describe VotingForm do
        let(:organization) {create(:organization)}
        let(:participatory_process) do
          create :participatory_process, organization: organization
        end
        let(:step) do
          create(:participatory_process_step, participatory_process: participatory_process)
        end
        let(:current_feature) do
          create :voting_feature, participatory_space: participatory_process
        end

        let(:context) do
          {
            current_organization: organization,
            current_feature: current_feature
          }
        end

        let(:title) {Decidim::Faker::Localized.sentence(3)}
        let(:description) {Decidim::Faker::Localized.sentence(3)}
        let(:image) {Decidim::Dev.test_file('city.jpeg', 'image/jpeg')}
        let(:start_date) {(DateTime.current + 1.days)}
        let(:end_date) {(DateTime.current + 2.days)}
        let(:scope) {create :scope, organization: organization}
        let(:scope_id) {scope.id}
        let(:importance) {::Faker::Number.number(2).to_i}
        let(:census_date_limit) {Date.today.strftime('%Y-%m-%dT%H:%M%S')}
        let(:status) {'simulation'}
        let(:voting_system) {'nVotes'}
        let(:voting_url) {'https://test.org'}
        let(:voting_identifier) {'identifier'}
        let(:shared_key) {'SHARED_KEY'}

        let(:attributes) do
          {
            title: title,
            description: description,
            image: image,
            start_date: start_date,
            end_date: end_date,
            decidim_scope_id: scope_id,
            importance: importance,
            census_date_limit: census_date_limit,
            status: status,
            voting_system: voting_system,
            voting_url: voting_url,
            voting_identifier: voting_identifier,
            shared_key: shared_key
          }
        end

        subject {described_class.from_params(attributes).with_context(context)}

        it {is_expected.to be_valid}

        describe 'when title is missing' do
          let(:title) {{en: nil}}
          it {is_expected.not_to be_valid}
        end

        describe 'when description is missing' do
          let(:description) {{en: nil}}
          it {is_expected.not_to be_valid}
        end

        describe "when the scope does not exist" do
          let(:scope_id) {scope.id + 10}

          it {is_expected.not_to be_valid}
        end

        describe "when start_date is after end_time" do
          let(:start_date) {end_date + 3.days}

          it {is_expected.not_to be_valid}
        end

        describe "when end_time is before start_time" do
          let(:end_date) {start_date - 3.days}

          it {is_expected.not_to be_valid}
        end


        context 'start_date' do
          context "is invalid when it's blank" do
            let(:start_date) {''}
            it {is_expected.not_to be_valid}
          end

          context 'is valid when it is inside step bounds' do
            let(:start_date) {step.end_date - 1.day}
            let(:end_date) {step.end_date}
            it {is_expected.to be_valid}
          end

          context 'is invalid when it is outside step bounds' do
            let(:start_date) {(step.start_date - 1.day)}
            it {is_expected.not_to be_valid}
          end
        end

        context 'end_date' do
          context "is invalid when it's blank" do
            let(:end_date) {''}
            it {is_expected.not_to be_valid}
          end

          context 'is valid when it is inside step bounds' do
            let(:start_date) {step.start_date}
            let(:end_date) {step.end_date - 1.day}
            it {is_expected.to be_valid}
          end

          context 'is invalid when it is outside step bounds' do
            let(:end_date) {step.end_date + 1.day}
            it {is_expected.not_to be_valid}
          end
        end

        context 'importance' do
          context "is invalid when it's blank" do
            let(:importance) {''}
            it {is_expected.not_to be_valid}
          end

          context 'is valid when it is an integer' do
            let(:importance) {'7'}
            it {is_expected.to be_valid}
          end

          context 'is invalid when it is not an integer' do
            let(:importance) {'nonumber'}
            it {is_expected.not_to be_valid}
          end
        end
      end
    end
  end
end
