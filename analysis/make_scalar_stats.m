% read all integral quantities from 2d hdf5 files and make
% a single file containing the time series


fields = {'entrained_tracer'};
fileformat = 'Data2d';

for mm = 1:length(fields)
    info = h5info('Data2d_0.h5','/integral');
    for nn = 1:length(info.Datasets)
        if strcmp(info.Datasets(nn).Name,fields{mm})
            field_exist = true;
            break
        else
            field_exist = false;
        end
    end

    if field_exist
        fieldname = ['/integral/',fields{mm}];

        Noutputs = last_output(fileformat);
        volume  = zeros(Noutputs,1);
        time = zeros(Noutputs,1);

        for ii = 1:Noutputs
            filename_2d = sprintf([fileformat,'_%d.h5'],ii-1);
            volume(ii)  = h5read(filename_2d, fieldname);
            time(ii) = h5read(filename_2d, '/time');

            completion(ii,Noutputs)
        end

        save(fields{mm},'time','volume');
    end
end
% need to multiply volume by 6/pi/Ly to get ratio of entrained fluid to particle volume
