// jshint nonew: false
'use strict';

Nightingale.Views['passwords-edit'] = Backbone.View.extend({
  initialize: function() {
    $('.toggle_password').each(function(index, element) {
      new Nightingale.Views.passwordField({el: element});
    });
  }
});
