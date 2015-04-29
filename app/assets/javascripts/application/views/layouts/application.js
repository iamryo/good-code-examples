// jshint nonew: false
'use strict';

Phoenix.Views['layouts/application'] = Backbone.View.extend({
  events: {
    'click .feedback_bar .icon' : 'dismissFlashMessage',
    'click #top_nav .menu_icon' : '_toggleLeftNav',
    'click .sidebar_offcanvas'  : '_toggleLeftNav',
    'click .left_nav_open .inner_content_offcanvas' : '_toggleLeftNav',
  },

  initialize: function() {
    this._initializeMetricsSearch();
  },

  _initializeMetricsSearch: function() {
    new Phoenix.Views['layouts/search_form']({
      applicationView: this,
      el: this.$('#top_nav')
    });
  },

  dismissFlashMessage: function() {
    $('.feedback_bar').hide();
  },

  lightenBackground: function() {
    this._setInnerContentOpacity(0.5);
  },

  showBackground: function() {
    this._setInnerContentOpacity(1);
  },

  hideBackground: function() {
    this._setInnerContentOpacity(0);
  },

  _setInnerContentOpacity: function(opacity) {
    this._innerContent().css('opacity', opacity);
  },

  _innerContent: function() {
    return this.$('.inner_content');
  },

  _toggleLeftNav: function() {
    $('.left_nav_toggle_handle').toggleClass('left_nav_open');
  },
});
