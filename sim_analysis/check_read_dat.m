function diag_data = check_read_dat(file_name)
% 1) checks if the:
%           - dat file needs to be cleaned, cleans it if necessary
%           - mat file is up to date, updates it if necessary
% 2) a) reads the cleaned, up to date file
%    b) or reads the original dat file

% check if cleaning is needed
if ~(exist([file_name,'.mat'], 'file') == 2)
    orig_file  = [file_name,'.dat'];
    orig_data  = readtable(orig_file);
    if min(diff(orig_data.time)) < 0
        % check if need to clean data
        msg = sprintf(['Simulation has been restarted and there are overlapping times,\n',...
            'Running "clean_dat_file(''%s'')" to remove the overlaps.\n'],file_name);
        fprintf(msg)
        clean_dat_file(file_name)
    end
end

% check if file is up to date
if exist([file_name,'.mat'], 'file') == 2
    % load files
    orig_file  = [file_name,'.dat'];
    clean_file = [file_name,'.mat'];
    orig_data  = readtable(orig_file);
    clean_data = load(clean_file);

    % check if cleaned data is up to date
    t_diff = orig_data.time(end) - clean_data.time(end);
    if t_diff > 0
        msg = sprintf(['Simulation is %5.2g ahead of cleaned mat file,\n',...
            'Running "clean_dat_file(''%s'')" to remove the overlaps.\n'],t_diff,file_name);
        fprintf(msg)
        clean_dat_file(file_name)
    end
end

% read appropriate file
if exist([file_name,'.mat'], 'file') == 2
    diag_data = load([file_name,'.mat']);
else
    diag_data = readtable([file_name,'.dat']);
end
