function n = build_ruler_file(folder, out_file)
%BUILD_RULER_FILE  Join the lab-day logs into one ruler-test file.
%   n = build_ruler_file('data/ruler_logs', 'data/ruler_test.csv')
%
%   On the lab day, log the Arduino's output to one file per distance, named by
%   the tape-measure distance: 5cm.csv, 10cm.csv, ..., 300cm.csv. Each file holds
%   the Arduino's lines (ms,temp_c,echo_us,d_fixed_cm,d_comp_cm), with or without
%   the header. This writes true_cm,temp_c,echo_us,d_fixed_cm,d_comp_cm, the
%   format analyze_ruler_test reads, and returns the number of lines written.
files = dir(fullfile(folder, '*cm.csv'));
if isempty(files), error('no *cm.csv files in %s', folder); end
fid = fopen(out_file, 'w');
fprintf(fid, 'true_cm,temp_c,echo_us,d_fixed_cm,d_comp_cm\n');
n = 0;
for k = 1:numel(files)
    tok = regexp(files(k).name, '^(\d+(\.\d+)?)cm\.csv$', 'tokens', 'once');
    if isempty(tok), continue; end
    dist = str2double(tok{1});
    in = fopen(fullfile(folder, files(k).name), 'r');
    while true
        line = fgetl(in);
        if ~ischar(line), break; end
        line = strtrim(line);
        c = strsplit(line, ',', 'CollapseDelimiters', false);
        if numel(c) ~= 5 || isnan(str2double(c{1})), continue; end   % header, half lines, messages
        fprintf(fid, '%g,%s,%s,%s,%s\n', dist, c{2:5});
        n = n + 1;
    end
    fclose(in);
end
fclose(fid);
end
