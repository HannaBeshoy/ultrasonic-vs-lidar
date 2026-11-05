function ok = missing_counted(tmp)
f = fullfile(tmp, 'm.csv');
fid = fopen(f, 'w');
fprintf(fid, 'true_cm,temp_c,echo_us,d_fixed_cm,d_comp_cm\n');
fprintf(fid, '100,20,5830,100.0,100.1\n100,20,0,,\n100,20,5836,100.1,100.2\n');
fclose(fid);
R = quiet_analyze(f);
ok = R.missing == 1 && R.table(1, 2) == 2 && R.table(1, 3) == 1 && abs(R.table(1, 4) - 0.05) < 1e-9;
end
