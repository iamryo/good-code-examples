'use strict';

Nightingale.Views['layouts/search_form'] = Backbone.View.extend({
  events: {
    'click .icon_search'           : '_expandSearch',
    'click .icon_close'            : '_toggleCloseIcon',
    'focus input'                  : '_handleInputFocus',
    'blur input'                   : '_handleInputBlur',
    'mousedown ul.results a'       : '_disableBlur',
    'mousedown .icon_close'        : '_disableBlur',
    'keyup input'                  : '_toggleSearchResults'
  },

  initialize: function(options) {
    this.options = options;
    this._blurDisabled = false;

    _.bindAll(this, '_autocompleteSource');
    _.bindAll(this, '_hideSearchResults');

    this._input().autocomplete({
      source: this._autocompleteSource
    });
  },

  _input: function() {
    return this.$('input');
  },

  _autocompleteSource: function(request, response) {
    this._searchResults().load(this._searchEndpoint(request.term));
    response([]);
  },

  _searchResults: function() {
    return this.$('ul.results');
  },

  _searchEndpoint: function(term) {
    return this.$('form').data('url') + '?term=' + encodeURIComponent(term);
  },

  _expandSearch: function() {
    this._toggleInputVisibility(true);
    this._input().focus();
  },

  _toggleInputVisibility: function(show) {
    this._input().toggle(show);
  },

  _toggleCloseIcon: function() {
    this._blurDisabled = false;
    this._input().val('').blur();
  },

  _handleInputFocus: function() {
    this._toggleSearchIcon(true);
    this._toggleMenuIcon(true);
    this._toggleBreadcrumbsAndResizeSearchBar(false);
    if (_.isEmpty(this._input().val())) {
      this.options.applicationView.lightenBackground();
    }
  },

  _handleInputBlur: function() {
    if (!this._blurDisabled) {
      this._toggleBreadcrumbsAndResizeSearchBar(true);
      this._toggleInputVisibility(false);
      this._hideSearchResults();
      this._toggleSearchIcon(false);
      this._toggleMenuIcon(false);
    }
  },

  _toggleSearchIcon: function(searching) {
    this.$('.icon_close').toggleClass('hidden', !searching);
    this.$('.icon_search').toggleClass('hidden', searching);
  },

  _toggleMenuIcon: function(searching) {
    this.$('.icon_list').toggleClass('hidden', searching);
    this.$('.icon_arrow_large_left').toggleClass('hidden', !searching);
  },

  _toggleBreadcrumbsAndResizeSearchBar: function(show) {
    this.$('.breadcrumbs').toggleClass('hidden', !show);
    this.$('.search').toggleClass('search_expanded', show);
  },

  _disableBlur: function() {
    this._blurDisabled = true;
  },

  _hideSearchResults: function() {
    this.options.applicationView.showBackground();
    this._searchResults().hide();
  },

  _toggleSearchResults: function(e) {
    if (_.isEmpty(this._input())) {
      this.options.applicationView.lightenBackground();
      this._searchResults().hide();
    } else {
      this.options.applicationView.hideBackground();
      this._searchResults().show();
    }
  },
});
