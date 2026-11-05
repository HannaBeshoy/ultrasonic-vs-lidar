function ok = csv_reader_ok(tmp)
f = fullfile(tmp, 'r.csv');
fid = fopen(f, 'w'); fprintf(fid, 'a,b,c\n1,,3\n# comment\n4,5,\n'); fclose(fid);
[d, names] = read_csv_numeric(f);
ok = isequal(names, {'a', 'b', 'c'}) && isequal(size(d), [2 3]) && isnan(d(1, 2)) && isnan(d(2, 3)) && d(2, 2) == 5;
end
