// jshint nonew: false
'use strict';

Phoenix.Views['users-new'] = Backbone.View.extend({
  initialize: function() {
    new Phoenix.Views.passwordField({el: '.toggle_password'});
  }
});
