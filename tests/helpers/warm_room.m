function ok = warm_room(tmp)
f = fullfile(tmp, 'w.csv');
simulate_ruler_test(f, 30, 2);
R = quiet_analyze(f);
ok = R.rms_comp < R.rms_fixed / 2;
end
