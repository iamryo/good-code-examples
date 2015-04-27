// This file is only used for the application, not for jasmine tests
//
// jshint nonew: false
'use strict';

Phoenix.initializeViews = function() {
  new Phoenix.Views['layouts/application']({el: '#body'});

  var viewName = $('body').data('viewName');
  var View = Phoenix.Views[viewName];

  if (View) {
    new View({
      el: '#body'
    });
  }
};
