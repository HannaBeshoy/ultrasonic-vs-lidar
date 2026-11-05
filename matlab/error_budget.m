function B = error_budget(d_cm)
%ERROR_BUDGET  Where the distance error of an HC-SR04 comes from, at distance d_cm.
%   B = error_budget(100)    prints and returns the contributions in mm
%
%   d = v*t/2, so a relative error in v or t is the same relative error in d.
%   The numbers are typical values, stated next to each line; the ruler test
%   on the lab day replaces them with measured ones.
if nargin < 1, d_cm = 100; end
d = d_cm * 10;                                         % mm
v20 = speed_of_sound(20);
items = {
    'unknown temperature, +-10 C, fixed 343 m/s',      d * (speed_of_sound(30) - v20) / v20
    'LM35 accuracy +-0.5 C, compensated',              d * 0.606 * 0.5 / v20
    'humidity 0 -> 100 % at 20 C (about +0.35 % in v)', d * 0.0035
    'linear vs ideal-gas formula at 25 C',             d * abs(speed_of_sound(25) - speed_of_sound(25, 'ideal')) / v20
    'pulseIn timing, about 4 us resolution',           4e-6 * v20 / 2 * 1000
    'echo detection jitter, about 5 us RMS',           5e-6 * v20 / 2 * 1000
    'tape measure and alignment, about 1 mm',          1
    };
B = cell2struct(items, {'source', 'mm'}, 2);
fprintf('\nError budget at %g cm\n', d_cm);
for i = 1:numel(B)
    fprintf('  %-52s %6.2f mm\n', B(i).source, B(i).mm);
end
comp = [B(2:end).mm];
fprintf('  %-52s %6.2f mm\n', 'total with compensation (root sum of squares)', sqrt(sum(comp .^ 2)));
fprintf('  %-52s %6.2f mm\n', 'total without compensation', sqrt(sum(comp(2:end) .^ 2) + B(1).mm ^ 2));
end
