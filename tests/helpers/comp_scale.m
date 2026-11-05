function ok = comp_scale(tmp)
f = fullfile(tmp, 'c.csv');
simulate_ruler_test(f, 26, 3);
R = quiet_analyze(f);
ok = abs(R.fit_comp(1) - 1) < 0.003;
end
