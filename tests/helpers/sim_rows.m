function n = sim_rows(tmp)
f = fullfile(tmp, 's.csv');
simulate_ruler_test(f, 26, 1);
d = read_csv_numeric(f);
n = size(d, 1);
end
