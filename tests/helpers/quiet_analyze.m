function R = quiet_analyze(f)
%QUIET_ANALYZE  analyze_ruler_test without the printed table.
[~, R] = evalc_wrap(f);
end

function [txt, R] = evalc_wrap(f)
R = [];
txt = evalc('R = analyze_ruler_test(f);');
end
