function [] = clean_dat_file(file)
    % clean_dat_file reads in a dat file and removes repeated times

    % read analysis file (if it exists)
    diag_file = [file,'.dat'];
    if exist(diag_file, 'file') == 2
        try
            diagnos = readtable(diag_file);
        catch
            warning(['file "',diag_file,'" incorrectly configured.'])
        end

        % find indices to keep
        time = diagnos.time;
        keep_inds = find_inds(time);

        % clean up diagnostics file
        names = fieldnames(diagnos);
        N_fields = length(names) - 1;
        new_diagnos = struct;
        for ii = 1:N_fields
            if ~isempty(strfind('Properties, Row', names{ii}))
                continue
            end
            temp = diagnos.(names{ii});
            new_diagnos.(names{ii}) = temp(keep_inds);
        end
        new_diagnos.Properties = diagnos.Properties;

        save([diag_file(1:end-4),'.mat'],'-struct','new_diagnos')
        disp(['Completed cleaning of ',diag_file])
    else
        disp([diag_file,' not found']);
    end

end % of function

function keep_inds = find_inds(time)
    % simplify time variable and find restarts
    step_time = [time(1); time(2:end)-time(1:end-1)];
    restart_inds = find(step_time<0);
    last_inds = [restart_inds-1; length(time)];   % last indices before a restart
    restart_time = time(restart_inds);
    N_restarts = length(last_inds);

    % find indices to keep (remove unwanted doubled time)
    for ii = 1:N_restarts
        if ii == 1
            keep_inds = 1:last_inds(ii);
        elseif ii > 1
            old_inds = keep_inds(time(keep_inds) < restart_time(ii-1));
            add_inds = (last_inds(ii-1)+1):last_inds(ii);
            keep_inds = [old_inds add_inds];
        end
    end

end % end of function
