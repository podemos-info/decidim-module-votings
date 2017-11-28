# frozen_string_literal: true

shared_examples 'manage votings' do
  let(:start_date) do
    current_feature.participatory_space.steps.first.start_date.strftime('%Y-%m-%d')
  end

  let(:end_date) do
    current_feature.participatory_space.steps.last.end_date.strftime('%Y-%m-%d')
  end

  context 'creates a new voting' do
    before do
      find('.card-title a.button').click
    end

    it 'with invalid data' do
      within '.new_voting' do
        fill_in :voting_voting_url, with: 'http://example.com'
        fill_in :voting_importance, with: '7'
        find('*[type=submit]').click
      end

      within '.callout-wrapper' do
        expect(page).to have_content('Check the form data and correct the errors')
      end

      expect(page).to have_content('NEW VOTING')
    end

    it 'with valid data' do
      fill_in_i18n(
        :voting_title,
        '#voting-title-tabs',
        en: 'My voting',
        es: 'Mi votación',
        ca: 'La meua votació'
      )

      fill_in_i18n_editor(
        :voting_description,
        '#voting-description-tabs',
        en: 'My voting description',
        es: 'La descripción de la votación',
        ca: 'La descripció de la votació'
      )

      fill_in :voting_importance, with: '1'

      find(:xpath, "//input[@id='voting_start_date']", visible: false).set start_date
      find(:xpath, "//input[@id='voting_end_date']", visible: false).set end_date

      within '.new_voting' do
        find('*[type=submit]').click
      end

      within '.callout-wrapper' do
        expect(page).to have_content('successfully')
      end

      within 'table' do
        expect(page).to have_content('My voting')
      end
    end
  end

  context 'updates a voting' do
    before do
      within find('tr', text: translated(voting.title)) do
        page.find('a.action-icon--edit').click
      end
    end

    it 'with invalid data' do
      within '.edit_voting' do
        fill_in :voting_importance, with: 'nonumber'
        find('*[type=submit]').click
      end

      within '.callout-wrapper' do
        expect(page).to have_content('Check the form data and correct the errors')
      end

      expect(page).to have_content('EDIT VOTING')
    end

    it 'with valid data' do
      within '.edit_voting' do
        fill_in_i18n(
          :voting_title,
          '#voting-title-tabs',
          en: 'My updated voting',
          es: 'Mi votación actualizada',
          ca: 'La meua votació actualitzada'
        )

        fill_in_i18n_editor(
          :voting_description,
          '#voting-description-tabs',
          en: 'My updated voting description',
          es: 'La descripción de la votación actualizada',
          ca: 'La descripció de la votació actualitzada'
        )
        fill_in :voting_importance, with: '1'

        find(:xpath, "//input[@id='voting_start_date']", visible: false).set start_date
        find(:xpath, "//input[@id='voting_end_date']", visible: false).set end_date

        find('*[type=submit]').click
      end

      within '.callout-wrapper' do
        expect(page).to have_content('successfully')
      end

      within 'table' do
        expect(page).to have_content('My updated voting')
      end
    end
  end

  context 'deleting a voting' do
    let!(:voting2) { create(:voting, feature: current_feature) }

    before do
      visit current_path
    end

    it 'deletes a voting' do
      within find('tr', text: translated(voting2.title)) do
        accept_confirm { page.find('a.action-icon--remove').click }
      end

      within '.callout-wrapper' do
        expect(page).to have_content('successfully')
      end

      within 'table' do
        expect(page).to have_no_content(translated(voting2.title))
      end
    end
  end

  context 'previewing votings' do
    it 'allows the user to preview the voting' do
      within find('tr', text: translated(voting.title)) do
        @new_window = window_opened_by { find('a.action-icon--preview').click }
      end

      within_window @new_window do
        expect(current_path).to eq resource_locator(voting).path
        expect(page).to have_content(translated(voting.title))
      end
    end
  end
end
