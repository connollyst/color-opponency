function [light, dark, red, yellow, green, blue] = V1SingleOpponent( I, varargin )
%V1SINGLEOPPONENT Simulate
%   Higher level integration of color channels by V1 (p1011)

    [pLo, mLo, pMo, mMo, pSo, mSo] = pLGN( I, varargin{:} );
    
    light  = pLo + pMo + pSo;
    dark   = mMo + mLo + mSo;
    red    = pLo + mMo + pSo;
    yellow = pLo + mMo + mSo;
    green  = pMo + mLo + mSo;
    blue   = pMo + mLo + pSo;
    
    if utils.do_show(varargin{:})
        utils.show_figure(11, 'light',  light);
        utils.show_figure(12, 'dark',   dark);
        utils.show_figure(13, 'red',    red);
        utils.show_figure(14, 'yellow', yellow);
        utils.show_figure(15, 'green',  green);
        utils.show_figure(16, 'blue',   blue);
    end

end

