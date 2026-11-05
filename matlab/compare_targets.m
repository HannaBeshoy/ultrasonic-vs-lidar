function compare_targets(file)
%COMPARE_TARGETS  Ultrasonic vs LiDAR on difficult targets.
%   compare_targets('data/targets.csv')
%   Columns: target,true_cm,ultrasonic_cm,lidar_cm,predicted
%   Leave a measurement empty if the sensor gave no reading. A reading counts as
%   correct when it is within 5 % (at least 2 cm) of the tape measure.
fid = fopen(file, 'r');
fgetl(fid);
fprintf('\n%-26s %8s | %-22s | %-22s | %s\n', 'target', 'true cm', 'ultrasonic', 'LiDAR', 'predicted');
while true
    line = fgetl(fid);
    if ~ischar(line), break; end
    if isempty(strtrim(line)) || line(1) == '#', continue; end
    c = strsplit(line, ',', 'CollapseDelimiters', false);
    while numel(c) < 5, c{end + 1} = ''; end %#ok<AGROW>
    tru = str2double(c{2});
    fprintf('%-26s %8g | %-22s | %-22s | %s\n', c{1}, tru, verdict(str2double(c{3}), tru), ...
            verdict(str2double(c{4}), tru), c{5});
end
fclose(fid);
end

function s = verdict(meas, tru)
if isnan(meas)
    s = 'not measured yet';
elseif meas == 0
    s = 'no reading';
elseif abs(meas - tru) <= max(2, 0.05 * tru)
    s = sprintf('ok (%.1f cm)', meas);
else
    s = sprintf('WRONG (%.1f cm)', meas);
end
end
