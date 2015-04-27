// jshint devel: true
'use strict';

Phoenix.Views['accounts-new'] = Backbone.View.extend({

  events: {
    'change .system_selection': '_loadProviders'
  },

  _loadProviders: function() {
    Phoenix.Util.loadProviders().done(function() {
      $('.system_selection option:empty').remove();
    });
  }
});
