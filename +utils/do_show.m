function show = do_show(varargin)
%DO_SHOW Utility function to determine if we should display anything.
    show = ~isempty(varargin) && strcmp(varargin{1},'display');
end

