// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function () {
  'use strict';

  var typeSelector = $('.votings .dependable'),
    refresh,
    targetElement,
    currentValue,
    searchUrl;

  if (typeSelector.length) {
    targetElement = $('#' + typeSelector.data('selector'));
    currentValue = typeSelector.data('scope-id');
    searchUrl = typeSelector.data('scope-search-url');

    if (targetElement.length) {
      refresh = function () {
        $.ajax({
          url: searchUrl,
          cache: false,
          dataType: 'html',
          data: {
            type_id: $(this).val(),
            selected: currentValue
          },
          success: function (data) {
            targetElement.html(data);
          }
        });
      };

      typeSelector.change(refresh);
    }
  }

});