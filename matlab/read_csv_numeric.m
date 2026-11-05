function [data, names] = read_csv_numeric(file)
%READ_CSV_NUMERIC  Read a CSV file with a header line; empty cells become NaN.
%   Works the same in MATLAB and Octave, without readtable.
fid = fopen(file, 'r');
if fid < 0, error('cannot open %s', file); end
header = fgetl(fid);
names = strsplit(strtrim(header), ',');
data = zeros(0, numel(names));
while true
    line = fgetl(fid);
    if ~ischar(line), break; end
    line = strtrim(line);
    if isempty(line) || line(1) == '#', continue; end
    cells = strsplit(line, ',', 'CollapseDelimiters', false);   % keep empty cells
    row = nan(1, numel(names));
    for c = 1:min(numel(cells), numel(names))
        x = str2double(cells{c});
        if ~isnan(x), row(c) = x; end
    end
    data(end + 1, :) = row; %#ok<AGROW>
end
fclose(fid);
end
