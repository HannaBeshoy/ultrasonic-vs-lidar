%RUN_TESTS  Checks for the analysis code. Run from the repository root:
%   octave --no-gui --eval "run('tests/run_tests.m')"   or   run('tests/run_tests.m') in MATLAB
here = fileparts(mfilename('fullpath'));
addpath(fullfile(here, '..', 'matlab'));
addpath(fullfile(here, 'helpers'));
tmp = tempname();
mkdir(tmp);

tests = {
  'linear formula at 0 C is 331.3 m/s',          @() abs(speed_of_sound(0) - 331.3) < 1e-9
  'linear formula at 20 C is 343.4 m/s',         @() abs(speed_of_sound(20) - 343.42) < 0.01
  'linear and ideal agree within 0.2 m/s to 20 C', @() max(abs(speed_of_sound(-10:20) - speed_of_sound(-10:20, 'ideal'))) < 0.21
  'and within 0.25 % up to 40 C',                @() max(abs(1 - speed_of_sound(-10:40) ./ speed_of_sound(-10:40, 'ideal'))) < 0.0025
  'speed works element-wise on vectors',         @() isequal(size(speed_of_sound([0 10 20])), [1 3])
  'unknown model is an error',                   @() throws(@() speed_of_sound(20, 'magic'))
  'CSV reader: empty cells become NaN',          @() csv_reader_ok(tmp)
  'simulation has 11 distances x 20 lines',      @() sim_rows(tmp) == 220
  'simulation is repeatable with the same seed', @() sim_repeatable(tmp)
  'compensated beats fixed in a warm room',      @() warm_room(tmp)
  'compensated scale is within 0.3 % of 1',      @() comp_scale(tmp)
  'fixed 343 m/s reads short at 26 C',          @() fixed_bias(tmp)
  'missing echoes are counted, not averaged',    @() missing_counted(tmp)
  'error budget: unknown T dominates at 1 m',    @() budget_order()
  'phyphox: v = 2d/(tA - tB)',                   @() phyphox_ok(tmp)
  'lab-day logs join into one ruler file',       @() build_ok(tmp)
};

fails = 0;
for i = 1:size(tests, 1)
    try
        ok = tests{i, 2}();
    catch err
        ok = false;
        fprintf('     error: %s\n', err.message);
    end
    if ok
        fprintf('PASS  %s\n', tests{i, 1});
    else
        fprintf('FAIL  %s\n', tests{i, 1});
        fails = fails + 1;
    end
end
fprintf('\n%d of %d tests passed\n', size(tests, 1) - fails, size(tests, 1));
if exist('OCTAVE_VERSION', 'builtin'), confirm_recursive_rmdir(false); end
rmdir(tmp, 's');
if fails > 0, error('%d tests failed', fails); end
