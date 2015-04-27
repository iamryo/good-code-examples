'use strict';

describe('Phoenix.Util.convertPixelsToRems', function() {
  it('returns correct rem value', function() {
    expect(Phoenix.Util.convertPixelsToRems(60)).toBe('3.75rem');
  });
});
