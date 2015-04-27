// jshint devel: true
'use strict';

Phoenix.Views['accounts-edit'] = Backbone.View.extend({

  events: {
    'change .system_selection': Phoenix.Util.loadProviders
  }
});
