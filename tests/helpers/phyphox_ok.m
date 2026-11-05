function ok = phyphox_ok(tmp)
f = fullfile(tmp, 'p.csv');
fid = fopen(f, 'w');
fprintf(fid, 'd_m,tA_s,tB_s,temp_c\n3.43,1.02,1.00,20\n3.43,2.02,2.00,20\n');
fclose(fid);
P = [];
evalc('P = phyphox_speed(f);');
ok = abs(P.mean - 343) < 1e-9 && P.sem < 1e-9;
end
