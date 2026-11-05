function R = analyze_ruler_test(file, out_csv)
%ANALYZE_RULER_TEST  Accuracy and repeatability of the ultrasonic meter against a tape measure.
%   R = analyze_ruler_test(file)            file: true_cm,temp_c,echo_us,d_fixed_cm,d_comp_cm
%   R = analyze_ruler_test(file, out_csv)   also writes the per-distance table
%
%   For each true distance: number of valid readings, missing echoes, mean error and
%   standard deviation with the fixed 343 m/s and with temperature compensation.
%   Then a straight-line fit measured = a*true + b over all valid readings, which
%   separates a scale error (a ~= 1: wrong speed of sound) from an offset (b ~= 0:
%   a fixed delay in the sensor).

[d, names] = read_csv_numeric(file);
col = @(n) d(:, strcmp(names, n));
tru = col('true_cm'); df = col('d_fixed_cm'); dc = col('d_comp_cm'); T = col('temp_c');
D = unique(tru);
R.table = zeros(numel(D), 8);
for i = 1:numel(D)
    m = tru == D(i);
    okf = m & ~isnan(df);
    ef = df(okf) - D(i);  ec = dc(okf) - D(i);
    R.table(i, :) = [D(i), nnz(okf), nnz(m & isnan(df)), mean(ef), std(ef), mean(ec), std(ec), mean(T(m))];
end
ok = ~isnan(df);
R.fit_fixed = polyfit(tru(ok), df(ok), 1);       % [scale, offset]
R.fit_comp  = polyfit(tru(ok), dc(ok), 1);
R.rms_fixed = sqrt(mean((df(ok) - tru(ok)) .^ 2));
R.rms_comp  = sqrt(mean((dc(ok) - tru(ok)) .^ 2));
R.mean_temp = mean(T);
R.missing   = nnz(~ok);

fprintf('\nRuler test: %s (mean temperature %.1f C)\n', file, R.mean_temp);
fprintf('%8s %5s %5s | %10s %8s | %10s %8s\n', 'true cm', 'n', 'miss', 'fixed err', 'sd', 'comp err', 'sd');
for i = 1:numel(D)
    fprintf('%8g %5d %5d | %+10.2f %8.2f | %+10.2f %8.2f\n', R.table(i, 1:7));
end
fprintf('RMS error: fixed 343 m/s %.2f cm, temperature-compensated %.2f cm\n', R.rms_fixed, R.rms_comp);
fprintf('Line fit, fixed:       measured = %.4f * true %+.2f cm\n', R.fit_fixed);
fprintf('Line fit, compensated: measured = %.4f * true %+.2f cm\n', R.fit_comp);
fprintf('Missing echoes: %d of %d\n', R.missing, numel(tru));

if nargin >= 2
    fid = fopen(out_csv, 'w');
    fprintf(fid, 'true_cm,n_valid,n_missing,err_fixed_cm,sd_fixed_cm,err_comp_cm,sd_comp_cm,mean_temp_c\n');
    fprintf(fid, '%g,%d,%d,%.3f,%.3f,%.3f,%.3f,%.2f\n', R.table');
    fclose(fid);
end
end
