// jshint nonew: false
'use strict';

Nightingale.Views['users-new'] = Backbone.View.extend({
  initialize: function() {
    new Nightingale.Views.passwordField({el: '.toggle_password'});
  }
});
