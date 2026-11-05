function ok = build_ok(tmp)
dirn = fullfile(tmp, 'logs');
mkdir(dirn);
fid = fopen(fullfile(dirn, '50cm.csv'), 'w');
fprintf(fid, 'ms,temp_c,echo_us,d_fixed_cm,d_comp_cm\n1000,22.5,2930,50.2,50.7\n1200,22.5,0,,\n12');
fclose(fid);
fid = fopen(fullfile(dirn, '100cm.csv'), 'w');
fprintf(fid, '1000,22.0,5840,100.2,101.0\n');
fclose(fid);
out = fullfile(tmp, 'joined.csv');
n = build_ruler_file(dirn, out);
d = read_csv_numeric(out);
d = sortrows(d, 1);
ok = n == 3 && isequal(size(d), [3 5]) && d(1, 1) == 50 && isnan(d(2, 4)) && d(3, 1) == 100 && d(3, 3) == 5840;
end
