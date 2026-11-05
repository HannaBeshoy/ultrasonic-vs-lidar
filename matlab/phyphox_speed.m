function P = phyphox_speed(file)
%PHYPHOX_SPEED  Speed of sound from the two-phone acoustic stopwatch method.
%   P = phyphox_speed(file)   file: d_m,tA_s,tB_s,temp_c (one line per trial)
%
%   A clap at phone A starts both stopwatches, a clap at phone B stops both:
%   tA = T + d/v and tB = T - d/v, so v = 2d / (tA - tB) (PSC notes p. 232).
%   The result is compared with 331.3 + 0.606*T at the measured temperature.
[x, names] = read_csv_numeric(file);
col = @(n) x(:, strcmp(names, n));
d = col('d_m'); tA = col('tA_s'); tB = col('tB_s'); T = col('temp_c');
ok = ~isnan(d) & ~isnan(tA) & ~isnan(tB);
v = 2 * d(ok) ./ (tA(ok) - tB(ok));
P.v = v;
P.mean = mean(v);
P.sem = std(v) / sqrt(numel(v));
P.theory = speed_of_sound(mean(T(ok)));
fprintf('\nphyphox two-phone method: %d trials\n', numel(v));
fprintf('  v = %.1f +- %.1f m/s (mean +- standard error)\n', P.mean, P.sem);
fprintf('  theory at %.1f C: %.1f m/s, difference %+.1f %%\n', mean(T(ok)), P.theory, 100 * (P.mean - P.theory) / P.theory);
end
