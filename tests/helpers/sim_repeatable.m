function ok = sim_repeatable(tmp)
a = fullfile(tmp, 'a.csv'); b = fullfile(tmp, 'b.csv');
simulate_ruler_test(a, 26, 7); simulate_ruler_test(b, 26, 7);
ok = isequal(fileread(a), fileread(b));
end
