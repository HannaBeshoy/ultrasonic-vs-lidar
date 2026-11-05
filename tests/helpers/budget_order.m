function ok = budget_order()
[~, B] = evalc_budget();
mm = [B.mm];
ok = mm(1) == max(mm) && mm(1) > 15 && mm(1) < 20;
end

function [txt, B] = evalc_budget()
B = [];
txt = evalc('B = error_budget(100);');
end
