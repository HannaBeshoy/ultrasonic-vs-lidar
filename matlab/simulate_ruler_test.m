function simulate_ruler_test(file, T_room, seed)
%SIMULATE_RULER_TEST  Write a simulated ruler test in the format of the real one.
%   simulate_ruler_test(file, T_room, seed)
%
%   Until the lab day, this stands in for the real measurement: the sensor is
%   placed at known distances from a flat wall (5 cm to 3 m) and 20 lines are
%   logged at each. Columns: true_cm,temp_c,echo_us,d_fixed_cm,d_comp_cm (the
%   Arduino's columns without the time, plus the tape-measure distance).
%
%   Model of the sensor (assumptions, to be replaced by the real data):
%     air at T_room (default 26 C, a warm lab), LM35 noise +-0.3 C and 0.49 C steps,
%     echo time = 2*d/v + 12 us fixed delay + 5 us RMS jitter, whole microseconds,
%     no echo (0) for 4 % of pings beyond 2.5 m.

if nargin < 2 || isempty(T_room), T_room = 26; end
if nargin < 3, seed = 1; end
rng(seed);
d_true = [5 10 20 30 50 75 100 150 200 250 300]';     % cm
n = 20;
v = speed_of_sound(T_room, 'ideal');                   % the real air
rows = zeros(numel(d_true) * n, 5);
k = 0;
for i = 1:numel(d_true)
    for j = 1:n
        k = k + 1;
        Tm = round((T_room + 0.3 * randn) / 0.489) * 0.489;          % LM35 through a 10-bit ADC
        echo = round(2 * d_true(i) / 100 / v * 1e6 + 12 + 5 * randn);
        if d_true(i) > 250 && rand < 0.04, echo = 0; end
        if echo == 0
            df = NaN; dc = NaN;
        else
            df = echo * 343 * 1e-4 / 2;
            dc = echo * speed_of_sound(Tm) * 1e-4 / 2;
        end
        rows(k, :) = [d_true(i), Tm, echo, round(df * 10) / 10, round(dc * 10) / 10];
    end
end
fid = fopen(file, 'w');
fprintf(fid, 'true_cm,temp_c,echo_us,d_fixed_cm,d_comp_cm\n');
for k = 1:size(rows, 1)
    if rows(k, 3) == 0
        fprintf(fid, '%g,%.1f,0,,\n', rows(k, 1), rows(k, 2));
    else
        fprintf(fid, '%g,%.1f,%d,%.1f,%.1f\n', rows(k, :));
    end
end
fclose(fid);
end
