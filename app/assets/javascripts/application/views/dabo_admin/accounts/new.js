// jshint devel: true
'use strict';

Nightingale.Views['accounts-new'] = Backbone.View.extend({

  events: {
    'change .system_selection': '_loadProviders'
  },

  _loadProviders: function() {
    Nightingale.Util.loadProviders().done(function() {
      $('.system_selection option:empty').remove();
    });
  }
});
