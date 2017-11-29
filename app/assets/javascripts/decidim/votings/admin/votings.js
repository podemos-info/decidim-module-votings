// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function () {
  'use strict';

  var $votingScopesEnabled = $('#voting_scopes_enabled');
  var $votingDecidimScopeId = $("#voting_decidim_scope_id");

  if ($('.edit_voting, .new_voting').length > 0) {
    $votingScopesEnabled.on('change', function (event) {
      var checked = event.target.checked;
      $votingDecidimScopeId.attr("disabled", !checked);
    });
    $votingDecidimScopeId.attr("disabled", !$votingScopesEnabled.prop('checked'));
  }

});