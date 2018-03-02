/* eslint-disable no-invalid-this */

$(() => {
  ((exports) => {
    const $votingScopesEnabled = $('#voting_scopes_enabled');
    const $votingDecidimScopeId = $("#voting_decidim_scope_id");

    if ($('.edit_voting, .new_voting').length > 0) {
      $votingScopesEnabled.on('change', function (event) {
        const checked = event.target.checked;
        exports.theDataPicker.enabled($votingDecidimScopeId, checked);
      })

      exports.theDataPicker.enabled($votingDecidimScopeId, $votingScopesEnabled.prop('checked'));
    }

    let electoralDistrictCounter = 0;

    const createElectoralDistrictId = () => {
      electoralDistrictCounter += 1;

      return `electoral-district-fields-${new Date().getTime()}-${electoralDistrictCounter}`;
    }

    $("form").on("click", ".add-electoral-district", function (event) {
      const id = createElectoralDistrictId();
      const content = $(this).data("form-content").replace("electoral-district-fields-id", id);

      $(this).before(content);
      exports.theDataPicker.activate(`#${id} .data-picker`);

      event.preventDefault();
    });

    $("form").on("click", ".remove-electoral-district", function (event) {
      const $removedFields = $(this).parents(".electoral-district-fields");
      const $deletedFields = $removedFields.find("input");
      const idInput = $deletedFields.filter((idx, input) => input.name.match(/\[id\]/));

      if (idInput.length > 0) {
        const deleteInput = $deletedFields.filter((idx, input) => input.name.match(/\[deleted\]/));

        if (deleteInput.length > 0) {
          $(deleteInput[0]).val(true);
        }

        $removedFields.addClass('hidden');
        $removedFields.hide();
      } else {
        $removedFields.remove();
      }

      event.preventDefault();
    });
  })(window);
});
