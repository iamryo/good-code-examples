// jshint nonew: false
'use strict';

Nightingale.Views['password_expired-show'] = Backbone.View.extend({
  initialize: function() {
    $('.toggle_password').each(function(index, element) {
      new Nightingale.Views.passwordField({el: element});
    });
  }
});
