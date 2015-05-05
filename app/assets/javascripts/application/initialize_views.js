// This file is only used for the application, not for jasmine tests
//
// jshint nonew: false
'use strict';

Nightingale.initializeViews = function() {
  new Nightingale.Views['layouts/application']({el: '#body'});

  var viewName = $('body').data('viewName');
  var View = Nightingale.Views[viewName];

  if (View) {
    new View({
      el: '#body'
    });
  }
};
