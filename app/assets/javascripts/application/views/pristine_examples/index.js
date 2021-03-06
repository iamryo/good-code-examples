// jshint devel: true
'use strict';

Nightingale.Views['pristine_examples-index'] = Backbone.View.extend({
  events: {
    'click #test': 'log'
  },

  initialize: function() {
    console.log('pristine_examples/index view initialized');
  },

  log: function() {
    console.log('Your click is received.');
    return false;
  }
});
