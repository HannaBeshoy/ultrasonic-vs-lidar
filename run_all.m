%RUN_ALL  Simulated ruler test, analysis, error budget and phyphox example.
%   Run from the repository root in MATLAB or Octave. The numbers come from
%   simulation until the lab-day files exist (data/ruler_test.csv, data/phyphox.csv).
addpath('matlab');
if ~exist('data/ruler_test.csv', 'file')
    simulate_ruler_test('data/ruler_test_simulated.csv', 26, 1);
    file = 'data/ruler_test_simulated.csv';
else
    file = 'data/ruler_test.csv';
end
R = analyze_ruler_test(file, 'results/ruler_summary.csv');
error_budget(100);
error_budget(300);
if exist('data/phyphox.csv', 'file')
    phyphox_speed('data/phyphox.csv');
else
    phyphox_speed('data/phyphox_example.csv');
end
compare_targets('data/targets.csv');

% speed of sound table for the README
T = (-10:5:40)';
fid = fopen('results/speed_of_sound.csv', 'w');
fprintf(fid, 'temp_c,v_linear,v_ideal,error_if_343_percent\n');
fprintf(fid, '%g,%.2f,%.2f,%.2f\n', [T, speed_of_sound(T), speed_of_sound(T, 'ideal'), ...
        100 * (343 - speed_of_sound(T, 'ideal')) ./ speed_of_sound(T, 'ideal')]');
fclose(fid);
