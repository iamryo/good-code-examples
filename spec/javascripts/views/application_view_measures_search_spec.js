// jshint nonew: false
'use strict';

describe('ApplicationViewMeasuresSearch', function() {
  var measuresFixturePath = 'measure_search_results_controller.html';
  var searchEndpoint = '/measure_search_results?term=';
  var search;
  var searchInput;
  var searchResults;
  var innerContent;

  beforeEach(function() {
    loadFixture(
      'public_charts_controller-get-show-generate-a-' +
      'fixture-with-conversations'
    );
    innerContent = $('.inner_content');
    new Phoenix.Views['layouts/application']({el: '#body', window: $('#body')});

    search = $('.search');
  });

  describe('for desktop', function() {
    beforeEach(function() {
      searchResults = search.find('ul.results');
      searchInput = search.find('input');
    });

    it('returns results for a search and hides main content', function() {
      stubAjaxRequest(searchEndpoint + 'patient', measuresFixturePath);
      searchAutocomplete(searchInput, 'patient');
      expect(searchResults).toContainElement(
        $('li.line_height_base.link')
      );
      expect(innerContent).toHaveCss({opacity: '0'});
    });
  });

  describe('for mobile and tablet portrait', function() {
    var topNav;
    var searchIcon;
    var menuIcon;
    var leftArrowIcon;

    beforeEach(function() {
      topNav = $('#top_nav');
      searchIcon = search.find('.icon_search');
      menuIcon = topNav.find('.icon_list');
      leftArrowIcon = topNav.find('.icon_arrow_large_left');
    });

    it('changes the menu icon to an arrow pointing left on focus', function() {
      searchIcon.click();
      expect(menuIcon).toHaveClass('hidden');
    });
  });
});
