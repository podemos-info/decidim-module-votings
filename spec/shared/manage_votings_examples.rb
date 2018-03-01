# frozen_string_literal: true

shared_examples "manage votings" do
  context "when creating a new voting" do
    before do
      find(".card-title a.button").click
    end

    it "properly toggles the scopes checkbox" do
      expect(page).to have_selector("#voting_decidim_scope_id", class: "disabled")

      check "Scopes enabled"

      expect(page).to have_no_selector("#voting_decidim_scope_id", class: "disabled")
    end

    context "with invalid data" do
      before do
        within ".new_voting" do
          fill_in :voting_voting_domain_name, with: "example.com"
          fill_in :voting_importance, with: "7"
          fill_in :voting_simulation_code, with: "5"
          find("*[type=submit]").click
        end
      end

      it "shows errors and redirects back to form" do
        within ".callout-wrapper" do
          expect(page).to have_content("Check the form data and correct the errors")
        end

        expect(page).to have_content("NEW VOTING")
      end
    end

    context "with valid data" do
      before do
        fill_in_voting_form(
          "en" => "My voting",
          "es" => "Mi votación",
          "ca" => "La meua votació"
        )

        within ".new_voting" do
          find("*[type=submit]").click
        end
      end

      it "shows a success message and redirects to voting list" do
        within ".callout-wrapper" do
          expect(page).to have_content("successfully")
        end

        within "table" do
          expect(page).to have_content("My voting")
        end
      end
    end
  end

  context "when updating a voting" do
    before do
      within find("tr", text: translated(voting.title)) do
        page.find("a.action-icon--edit").click
      end
    end

    context "with invalid data" do
      before do
        within ".edit_voting" do
          fill_in :voting_importance, with: "nonumber"
          fill_in :voting_simulation_code, with: "5"
          find("*[type=submit]").click
        end
      end

      it "shows errors and redirects back to form" do
        within ".callout-wrapper" do
          expect(page).to have_content("Check the form data and correct the errors")
        end

        expect(page).to have_content("EDIT VOTING")
      end
    end

    context "with valid data" do
      before do
        fill_in_voting_form(
          "en" => "My updated voting",
          "es" => "Mi votación actualizada",
          "ca" => "La meua votació actualitzada"
        )

        within ".edit_voting" do
          find("*[type=submit]").click
        end
      end

      it "shows a sucess message and redirects to voting list" do
        within ".callout-wrapper" do
          expect(page).to have_content("successfully")
        end

        within "table" do
          expect(page).to have_content("My updated voting")
        end
      end
    end
  end

  context "when deleting a voting" do
    let!(:voting2) { create(:voting, feature: current_feature) }

    before do
      visit current_path
    end

    it "deletes a voting" do
      within find("tr", text: translated(voting2.title)) do
        accept_confirm { page.find("a.action-icon--remove").click }
      end

      within ".callout-wrapper" do
        expect(page).to have_content("successfully")
      end

      within "table" do
        expect(page).to have_no_content(translated(voting2.title))
      end
    end
  end

  context "when previewing votings" do
    it "allows the user to preview the voting" do
      new_window = nil
      within find("tr", text: translated(voting.title)) do
        new_window = window_opened_by { find("a.action-icon--preview").click }
      end

      within_window new_window do
        expect(page).to have_current_path(resource_locator(voting).path(key: voting.simulation_key))
        expect(page).to have_content(translated(voting.title))
      end
    end
  end

  private

  def fill_in_voting_form(title)
    fill_in_i18n(
      :voting_title,
      "#voting-title-tabs",
      en: title["en"],
      es: title["es"],
      ca: title["ca"]
    )

    fill_in_i18n_editor(
      :voting_description,
      "#voting-description-tabs",
      en: "My voting description",
      es: "La descripción de la votación",
      ca: "La descripció de la votació"
    )

    fill_in :voting_importance, with: "1"
    fill_in :voting_simulation_code, with: "5"

    page.execute_script("$('#datetime_field_voting_start_date').focus()")
    page.find(".datepicker-dropdown .day", text: "12").click
    page.find(".datepicker-dropdown .hour", text: "10:00").click
    page.find(".datepicker-dropdown .minute", text: "10:50").click

    page.execute_script("$('#datetime_field_voting_end_date').focus()")
    page.find(".datepicker-dropdown .day", text: "12").click
    page.find(".datepicker-dropdown .hour", text: "12:00").click
    page.find(".datepicker-dropdown .minute", text: "12:50").click
  end
end
