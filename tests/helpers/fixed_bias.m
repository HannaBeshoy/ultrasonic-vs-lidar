function ok = fixed_bias(tmp)
% at 26 C the real speed is about 347 m/s, so 343 m/s turns each echo into a
% shorter distance: the scale of the fixed fit is about 343/347 = 0.988
f = fullfile(tmp, 'f.csv');
simulate_ruler_test(f, 26, 4);
R = quiet_analyze(f);
ok = abs(R.fit_fixed(1) - 343 / speed_of_sound(26, 'ideal')) < 0.003;
end
