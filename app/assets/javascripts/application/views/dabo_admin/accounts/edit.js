// jshint devel: true
'use strict';

Nightingale.Views['accounts-edit'] = Backbone.View.extend({

  events: {
    'change .system_selection': Nightingale.Util.loadProviders
  }
});
