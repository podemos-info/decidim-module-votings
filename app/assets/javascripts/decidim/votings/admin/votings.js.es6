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
  })(window);
});