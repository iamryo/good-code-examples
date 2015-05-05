'use strict';

describe('Nightingale.Util.convertPixelsToRems', function() {
  it('returns correct rem value', function() {
    expect(Nightingale.Util.convertPixelsToRems(60)).toBe('3.75rem');
  });
});
